if status is-interactive
    # Commands to run in interactive sessions can go here
end

eval (/opt/homebrew/bin/brew shellenv)

set -x HOMEBREW_API_DOMAIN "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
set -x HOMEBREW_BREW_GIT_REMOTE "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"

# export PATH="$HOME/.local/bin:$HOME/go/bin:$HOME/.gem/ruby/2.6.0/bin:/usr/local/bin:/usr/local/go/bin:$PATH"
set -gx PATH "$HOME/.local/bin" $HOME/go/bin $HOME/.gem/ruby/2.6.0/bin /usr/local/bin /usr/local/go/bin $PATH
set -gx PATH "$HOME/.cargo/bin" $PATH

function ap
    git -C "$HOME/dotfiles" pull
    git -C "$HOME/github.com/symmetrical-dollop" pull
    git -C "$HOME/playground" pull
    git -C "$HOME/github.com/obsidian-vault" pull
end

abbr -a gst git status
abbr -a gc git commit --verbose 
abbr -a gd git diff
abbr -a gaa git add --all
abbr -a vim nvim

set -gx FZF_DEFAULT_OPTS "--preview-window 'right:57%' --preview 'bat --style=numbers --line-range :300 {}' --bind ctrl-y:preview-up,ctrl-e:preview-down,ctrl-b:preview-page-up,ctrl-f:preview-page-down,ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down,shift-up:preview-top,shift-down:preview-bottom,alt-up:half-page-up,alt-down:half-page-down" 
set -gx FZF_DEFAULT_COMMAND "fd --hidden --type f" 

function Proxy
    if test $argv[1] = "on" 
        set -gx https_proxy localhost:7890
        set -gx http_proxy localhost:7890
        echo Proxy On $https_proxy
    else
        set -e https_proxy
        set -e http_proxy
        echo Proxy Off
    end
end

function GoSwitch
    if test (count $argv) -lt 2; or test $argv[1] = ""
        echo "Please input the go version. Use y to confirm"
        echo $(ls $HOME/sdk)
    else
        set --function gosdk $HOME/sdk/go$argv[1]
        echo gosdk $gosdk
        if test $argv[2] = "y"
            sudo rm /usr/local/go
            sudo ln -s $gosdk /usr/local/go
            echo "switch to $gosdk"
        else
            echo "switch to $gosdk, use y to confirm"
        end
    end
end

# For set/get Mac OS X proxy settings by command line
# check `man networksetup` for more
function SysProxy
    if test (count $argv)  -lt 1
        echo "SysProxy usage:"
        echo -e "\tall: list all network services\n"
        echo -e "\tget [networkservice]\n"
        echo -e "\tset [networkservice] [host] [port]\n"
        echo -e "\treset\n"
        return
    end
    set service "Wi-Fi"
    set ip "127.0.0.1"
    set port "7890"
    # declare -a bypassdomains
    set bypassdomains "192.168.0.0/16" "10.0.0.0/8" "172.16.0.0/12" "127.0.0.1" \
    "localhost" "*.local" "timestamp.apple.com" "sequoia.apple.com" "seed-sequoia.siri.apple.com"
    echo $bypassdomains
    # for i ("$bypassdomains[@]") echo $i
    # return
    # declare -r bypassdomains
    set oper $argv[1]
    if test $oper = "all" 
        networksetup -listallnetworkservices # case insensitive
    else if test $oper = "get" 
        echo "[webproxy]: $service" 
        networksetup -getwebproxy $service
        echo "[securewebproxy]: $service" 
        networksetup -getsecurewebproxy $service
        echo "[socks]: $service" 
        networksetup -getsocksfirewallproxy $service
        echo "[bypass domains"]
        networksetup -getproxybypassdomains $service
    else if test $oper = "set" 
        networksetup -setwebproxy $service $ip $port
        networksetup -setsecurewebproxy $service $ip $port
        networksetup -setsocksfirewallproxy $service $ip $port
        networksetup -setproxybypassdomains $service $bypassdomains
    else if test $oper = "reset"
        networksetup -setwebproxystate $service off
        networksetup -setsecurewebproxystate $service off
        networksetup -setsocksfirewallproxystate $service off
        networksetup -setproxybypassdomains $service "Empty"
    end
    # networksetup -setwebproxy "Wi-fi" 127.0.0.1 8080
end

zoxide init fish | source
set -gx VISUAL vim

bind \cx\ce edit_command_buffer
