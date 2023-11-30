eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"

#PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
# PATH="/usr/local/go/bin/go:$PATH"
alias docs='cd ~/github.com/symmetrical-dollop/docs'
alias dot='cd ~/dotfiles'

export PATH="$HOME/.local/bin:$HOME/go/bin:$HOME/.gem/ruby/2.6.0/bin:/usr/local/bin:/usr/local/go/bin:$PATH"
alias sn="syncnotes -f -p -o $HOME/github.com/symmetrical-dollop"
alias snd="syncnotes -f -p -o $HOME/dotfiles"
alias dp='git -C "$HOME/dotfiles" pull'
alias np='git -C "$HOME/github.com/symmetrical-dollop" pull'
alias pp='git -C "$HOME/playground" pull'
alias op='git -C "$HOME/github.com/obsidian-vault" pull'
alias ap='dp&&np&&pp&&op'
alias vim='nvim'
alias tmuxn='TERM=xterm-256color tmux new-session -t'
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

export FZF_DEFAULT_OPTS="--preview-window 'right:57%' --preview 'bat --style=numbers --line-range :300 {}' --bind ctrl-y:preview-up,ctrl-e:preview-down,ctrl-b:preview-page-up,ctrl-f:preview-page-down,ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down,shift-up:preview-top,shift-down:preview-bottom,alt-up:half-page-up,alt-down:half-page-down" 
export FZF_DEFAULT_COMMAND="fd --hidden --type f" 

# brew info autojump and you will get it
[ -f /usr/local/etc/autojump.sh ] && . /usr/local/etc/autojump.sh

alias python='python3'

export PATH="/opt/homebrew/opt/python@3.11/libexec/bin:$PATH"

function Proxy() {
    ip=${SSH_CLIENT/ */}
    if [[ "$1" == "on" ]]; then
        export https_proxy=localhost:7890
        export http_proxy=localhost:7890
        echo Proxy On
    else
        unset https_proxy
        unset http_proxy
        echo Proxy Off
    fi
}

function GoSwitch() {
    if [[ "$1" == "" ]]; then
        echo "Please input the go version."
        echo $(ls $HOME/sdk)
    else
        gosdk=$HOME/sdk/go$1
        if [[ "$2" == "y" ]]; then
            sudo rm /usr/local/go
            sudo ln -s $gosdk /usr/local/go
            echo "switch to $gosdk"
        else
            echo "switch to $gosdk, add y to confirm"
        fi
    fi
}

# For set/get Mac OS X proxy settings by command line
# check `man networksetup` for more

function SysProxy() {
    if [[ $# -eq 0 ]]; then
        echo "SysProxy usage:"
        echo -n "\tall: list all network services\n"
        echo -n "\tget [networkservice]\n"
        echo -n "\tset [networkservice] [host] [port]\n"
        echo -n "\treset\n"
        return
    fi
    service="Wi-Fi"
    ip="127.0.0.1"
    port="7890"
    # declare -a bypassdomains
    bypassdomains=(
    "192.168.0.0/16"
    "10.0.0.0/8"
    "172.16.0.0/12"
    "127.0.0.1"
    "localhost"
    "*.local"
    "timestamp.apple.com"
    "sequoia.apple.com"
    "seed-sequoia.siri.apple.com"
    )
    # echo $bypassdomains
    # for i ("$bypassdomains[@]") echo $i
    # return
    # declare -r bypassdomains
    if [[ "$1" == "all" ]]; then
        networksetup -listallnetworkservices # case insensitive
    elif [[ "$1" == "get" ]]; then
        echo "[webproxy]: $service" 
        networksetup -getwebproxy $service
        echo "[securewebproxy]: $service" 
        networksetup -getsecurewebproxy $service
        echo "[socks]: $service" 
        networksetup -getsocksfirewallproxy $service
        echo "[bypass domains"]
        networksetup -getproxybypassdomains $service
    elif [[ "$1" == "set" ]]; then
        networksetup -setwebproxy $service $ip $port
        networksetup -setsecurewebproxy $service $ip $port
        networksetup -setsocksfirewallproxy $service $ip $port
        networksetup -setproxybypassdomains $service $bypassdomains
    elif [[ "$1" == "reset" ]]; then
        networksetup -setwebproxystate $service off
        networksetup -setsecurewebproxystate $service off
        networksetup -setsocksfirewallproxystate $service off
        networksetup -setproxybypassdomains $service "Empty"
    fi
    # networksetup -setwebproxy "Wi-fi" 127.0.0.1 8080
}
