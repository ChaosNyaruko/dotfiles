eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"

#PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
# PATH="/usr/local/go/bin/go:$PATH"
alias docs='cd ~/github.com/symmetrical-dollop/docs'
alias dot='cd ~/dotfiles'

export PATH="$HOME/.local/bin:$HOME/go/bin:$HOME/.gem/ruby/2.6.0/bin:/usr/local/bin:$PATH"
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
    export http_proxy=socks5://127.0.0.1:10001
    export https_proxy=socks5://127.0.0.1:10001
    export all_proxy=socks5://127.0.0.1:10001
    echo $http_proxy
    echo $https_proxy
    echo $all_proxy
}

unsetproxy() {
    echo "unsetting proxy"
    unset http_proxy
    unset https_proxY
    unset all_proxy
    echo $http_proxy
    echo $https_proxY
    echo $all_proxy
}
