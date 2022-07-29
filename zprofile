eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"

#PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
# PATH="/usr/local/go/bin/go:$PATH"
alias docs='cd ~/github.com/symmetrical-dollop/docs'
alias dot='cd ~/dotfiles'
alias nvi='nvim -u ~/.config/nvim_bak/init.lua'

export PATH="$HOME/go/bin:$HOME/.gem/ruby/2.6.0/bin:$PATH"
alias sn="syncnotes -f -p -o $HOME/github.com/symmetrical-dollop"
alias snd="syncnotes -f -p -o $HOME/dotfiles"
alias dp='git -C "$HOME/dotfiles" pull'
alias np='git -C "$HOME/github.com/symmetrical-dollop" pull'
if [ ~/z/z.sh ]; then
    source ~/z/z.sh
else
    echo "do not exit z"
fi

setproxy() {
    echo "setting proxy"
    export HTTP_PROXY=socks5://127.0.0.1:10001
    export HTTPS_PROXY=socks5://127.0.0.1:10001
    export ALL_PROXY=socks5://127.0.0.1:10001
    echo $HTTP_PROXY
    echo $HTTPS_PROXY
    echo $ALL_PROXY
}

unsetproxy() {
    echo "unsetting proxy"
    unset HTTP_PROXY
    unset HTTPS_PROXY
    unset ALL_PROXY
    echo $HTTP_PROXY
    echo $HTTPS_PROXY
    echo $ALL_PROXY
}
