#!/usr/bin/env bash
#
# gpg-backup.sh — 备份所有 GPG 私钥、对应公钥与撤销证书，并自检导入
#
# 用法：
#   ./gpg-backup.sh [目标父目录]
# 不传参数时，默认在 $HOME 下生成临时工作目录，
# 最终打包成 ~/gpg-backup-<时间戳>.tar.gz（权限 600），临时目录会被清理。

set -euo pipefail

DEST_PARENT="${1:-$HOME}"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
WORKDIR="${DEST_PARENT}/gpg-backup-${TIMESTAMP}"
ARCHIVE="${DEST_PARENT}/gpg-backup-${TIMESTAMP}.tar.gz"

mkdir -p "$WORKDIR"
chmod 700 "$WORKDIR"

echo "==> 收集 secret key 列表..."
# 只取每个密钥对的主键指纹（sec 行后紧跟的 fpr），导出时会自动带上其所有子密钥
# 用 while-read 而不是 mapfile，兼容 macOS 自带的 bash 3.2
FPRS=()
while IFS= read -r line; do
  [ -n "$line" ] && FPRS+=("$line")
done < <(
  gpg --list-secret-keys --with-colons |
  awk -F: '
    $1 == "sec" { want = 1; next }
    $1 == "fpr" && want { print $10; want = 0 }
    $1 != "fpr" { want = 0 }
  '
)

if [ "${#FPRS[@]}" -eq 0 ]; then
  echo "未找到任何 secret key，退出。"
  exit 1
fi

for FPR in "${FPRS[@]}"; do
  echo "==> 导出密钥 $FPR"
  gpg --export-secret-keys --armor "$FPR" > "${WORKDIR}/secret-${FPR}.asc"
  gpg --export --armor "$FPR" > "${WORKDIR}/public-${FPR}.asc"

  REV="${HOME}/.gnupg/openpgp-revocs.d/${FPR}.rev"
  if [ -f "$REV" ]; then
    cp "$REV" "${WORKDIR}/revcert-${FPR}.rev"
  else
    echo "    警告：找不到 $FPR 的撤销证书 ($REV)"
  fi
done

echo "==> 导出 ownertrust（信任设置，体积很小，一起备份）"
gpg --export-ownertrust > "${WORKDIR}/ownertrust.txt"

cat > "${WORKDIR}/README.txt" <<EOF
GPG 备份 — 生成时间：${TIMESTAMP}

包含内容：
  secret-<fingerprint>.asc   私钥（含子密钥，仍受你的 GPG 密码保护）
  public-<fingerprint>.asc   对应公钥
  revcert-<fingerprint>.rev  撤销证书（密钥丢失/泄露时用来宣布作废）
  ownertrust.txt             信任数据库设置

恢复方法：
  gpg --import secret-<fingerprint>.asc
  gpg --import-ownertrust ownertrust.txt

注意：
  - 这份备份包含私钥材料，请勿明文上传到不受信任的位置。
  - 撤销证书一旦公开发布，对应密钥即被判定失效，请只在必要时使用。
EOF

chmod 600 "${WORKDIR}"/*

echo "==> 自检：在隔离的临时 GNUPGHOME 中尝试导入，验证备份文件可用"
TMP_GNUPGHOME="$(mktemp -d)"
chmod 700 "$TMP_GNUPGHOME"
SELF_TEST_OK=1
for FPR in "${FPRS[@]}"; do
  if ! GNUPGHOME="$TMP_GNUPGHOME" gpg --batch --import "${WORKDIR}/secret-${FPR}.asc" >/dev/null 2>&1; then
    echo "    ✗ $FPR 导入自检失败"
    SELF_TEST_OK=0
  else
    echo "    ✓ $FPR 导入自检通过"
  fi
done
rm -rf "$TMP_GNUPGHOME"

if [ "$SELF_TEST_OK" -ne 1 ]; then
  echo "自检未全部通过，请检查上面的错误信息；备份文件已生成但可能有问题。" >&2
fi

echo "==> 打包为 ${ARCHIVE}"
tar -czf "$ARCHIVE" -C "$DEST_PARENT" "gpg-backup-${TIMESTAMP}"
chmod 600 "$ARCHIVE"

rm -rf "$WORKDIR"

echo "完成：$ARCHIVE"
echo "建议：把这个文件复制到至少一个离线/异地位置保存。"
