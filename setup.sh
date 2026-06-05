#!/bin/bash
set -euo pipefail

DOTFILEREPO="${DOTFILEREPO:-$HOME/dotfiles}"
Z_SH_URL="https://raw.githubusercontent.com/rupa/z/master/z.sh"
BASHRC_MARKER="# dotfiles setup.sh (z)"

usage() {
    cat <<'EOF'
Usage: ./setup.sh <command>

Commands:
  pc       Symlink tmux/neovim/gitconfig/fish/alacritty/bins/.vimrc
  server   Install tmux, download z.sh, symlink tmux, update ~/.bashrc
  help     Show this help

Optional:
  --clean, -c   Remove backup files (*_bak*)
  --share       Copy share/* to ~/.local/share/
  --list, -l    List backup files

Environment:
  DOTFILEREPO   Dotfiles repo path (default: ~/dotfiles)
EOF
}

show_bak_files() {
    shopt -s nullglob
    echo "existing bak files:"
    ls -l ~/*_bak* ~/.config/**/*_bak* 2>/dev/null || true
    shopt -u nullglob
}

clean_bak_files() {
    shopt -s nullglob
    local files=(~/*_bak* ~/.config/**/*_bak*)
    if ((${#files[@]})); then
        rm -rf "${files[@]}"
    fi
    shopt -u nullglob
    echo "clean over"
}

ensure_dotfiles() {
    if [[ -d "$DOTFILEREPO/.git" ]]; then
        echo "dotfiles repo: $DOTFILEREPO"
        return 0
    fi

    echo "cloning dotfiles to $DOTFILEREPO..."
    if git clone git@github.com:ChaosNyaruko/dotfiles.git "$DOTFILEREPO"; then
        return 0
    fi

    echo "ssh clone failed, trying https..."
    git clone https://github.com/ChaosNyaruko/dotfiles.git "$DOTFILEREPO"
}

resolve_path() {
    local path="$1"
    if command -v realpath >/dev/null 2>&1; then
        realpath "$path"
    elif command -v python3 >/dev/null 2>&1; then
        python3 -c 'import os, sys; print(os.path.realpath(sys.argv[1]))' "$path"
    else
        (
            cd "$(dirname "$path")" || exit 1
            echo "$(pwd -P)/$(basename "$path")"
        )
    fi
}

backup_and_remove() {
    local target="$1"

    if [[ -L "$target" ]]; then
        rm -f "$target"
        return 0
    fi

    if [[ -e "$target" ]]; then
        local backup="${target}_bak$(date "+%Y%m%d_%H%M%S")"
        echo "backing up $target -> $backup"
        mv "$target" "$backup"
    fi
}

link_item() {
    local target="$1"
    local source="$2"

    if [[ ! -e "$source" ]]; then
        echo "error: source not found: $source" >&2
        exit 1
    fi

    mkdir -p "$(dirname "$target")"

    if [[ -L "$target" ]]; then
        local current resolved_source
        current="$(readlink "$target")"
        resolved_source="$(resolve_path "$source")"
        if [[ "$(resolve_path "$target")" == "$resolved_source" ]]; then
            echo "skip (already linked): $target -> $source"
            return 0
        fi
        echo "replacing symlink: $target ($current) -> $source"
    elif [[ -e "$target" ]]; then
        backup_and_remove "$target"
    else
        echo "creating link: $target -> $source"
    fi

    ln -sfn "$source" "$target"
    echo "linked: $target -> $source"
}

setup_pc() {
    echo "setting up pc mode..."
    link_item "$HOME/.vimrc" "$DOTFILEREPO/vimrc"
    link_item "$HOME/.config/nvim" "$DOTFILEREPO/nvim"
    link_item "$HOME/.gitconfig" "$DOTFILEREPO/gitconfig"
    link_item "$HOME/.config/fish" "$DOTFILEREPO/fish"
    link_item "$HOME/.config/alacritty" "$DOTFILEREPO/alacritty"
    link_item "$HOME/.config/tmux" "$DOTFILEREPO/tmux"
    link_item "$HOME/.local/share/bin" "$DOTFILEREPO/bin"
    echo "pc setup complete"
}

install_tmux() {
    if command -v tmux >/dev/null 2>&1; then
        echo "tmux already installed: $(tmux -V)"
        return 0
    fi

    echo "installing tmux..."
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install -y tmux
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y tmux
    elif command -v yum >/dev/null 2>&1; then
        sudo yum install -y tmux
    elif command -v brew >/dev/null 2>&1; then
        brew install tmux
    else
        echo "error: no supported package manager found for tmux" >&2
        exit 1
    fi

    echo "tmux installed: $(tmux -V)"
}

install_z() {
    local z_dir="$HOME/z"
    local z_file="$z_dir/z.sh"

    mkdir -p "$z_dir"

    echo "downloading z.sh to $z_file..."
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$Z_SH_URL" -o "$z_file"
    elif command -v wget >/dev/null 2>&1; then
        wget -qO "$z_file" "$Z_SH_URL"
    else
        echo "error: curl or wget required to download z.sh" >&2
        exit 1
    fi

    echo "z.sh downloaded: $z_file"
}

setup_bashrc_z() {
    local bashrc="$HOME/.bashrc"
    local source_line='[ -f "$HOME/z/z.sh" ] && . "$HOME/z/z.sh"'

    touch "$bashrc"

    if grep -qF "$BASHRC_MARKER" "$bashrc" || grep -qF 'z/z.sh' "$bashrc"; then
        echo "bashrc already sources z.sh, skipping"
        return 0
    fi

    {
        echo ""
        echo "$BASHRC_MARKER"
        echo "$source_line"
    } >>"$bashrc"

    echo "appended z.sh source to $bashrc"
}

setup_server() {
    echo "setting up server mode..."
    install_tmux
    install_z
    link_item "$HOME/.config/tmux" "$DOTFILEREPO/tmux"
    setup_bashrc_z
    echo "server setup complete"
}

copy_share() {
    if [[ ! -d "$DOTFILEREPO/share" ]]; then
        echo "error: $DOTFILEREPO/share not found" >&2
        exit 1
    fi
    mkdir -p "$HOME/.local/share"
    cp -v -r "$DOTFILEREPO/share/"* "$HOME/.local/share/"
}

main() {
    local cmd="${1:-}"

    case "$cmd" in
        pc)
            ensure_dotfiles
            setup_pc
            ;;
        server)
            ensure_dotfiles
            setup_server
            ;;
        help | --help | -h | "")
            usage
            ;;
        --clean | -c)
            show_bak_files
            clean_bak_files
            ;;
        --share)
            ensure_dotfiles
            copy_share
            ;;
        --list | -l)
            show_bak_files
            ;;
        *)
            echo "unsupported command: $cmd" >&2
            usage
            exit 1
            ;;
    esac
}

main "$@"
