if status is-interactive
    # Commands to run in interactive sessions can go here
end

if command -v /opt/homebrew/bin/brew > /dev/null
    eval (/opt/homebrew/bin/brew shellenv)
end

# set -x HOMEBREW_API_DOMAIN "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
# set -x HOMEBREW_BREW_GIT_REMOTE "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"

# export PATH="$HOME/.local/bin:$HOME/go/bin:$HOME/.gem/ruby/2.6.0/bin:/usr/local/bin:/usr/local/go/bin:$PATH"
set -gx PATH "$HOME/.local/bin" $HOME/go/bin $HOME/.gem/ruby/2.6.0/bin /usr/local/bin /usr/local/go/bin $PATH
set -gx PATH "$HOME/.cargo/bin" $PATH
# fish_add_path -m "$HOME/.local/bin" $HOME/go/bin $HOME/.gem/ruby/2.6.0/bin /usr/local/bin /usr/local/go/bin
# fish_add_path -m "$HOME/.cargo/bin"
function ap
    git -C "$HOME/dotfiles" pull
    git -C "$HOME/github.com/symmetrical-dollop" pull
    git -C "$HOME/github.com/playground" pull
    git -C "$HOME/github.com/obsidian-vault" pull
end

abbr -a tt gdate +\"%Y-%m-%d %H:%M:%S\"
abbr -a gst git status
abbr -a gc git commit --verbose 
abbr -a gcm git commit -m
abbr -a gd git diff
abbr -a gaa git add --all
abbr -a diff nvim -d
# abbr -a gctt git commit -m \'$(gdate +'%Y-%m-%d %H:%M:%S')\'
abbr -a gctt git commit -m  \"'$(gdate +\'%Y-%m-%d %H:%M:%S\')'\"

set -gx FZF_DEFAULT_OPTS "--preview-window 'right:57%' --preview 'bat --style=numbers --line-range :300 {}' --bind ctrl-y:preview-up,ctrl-e:preview-down,ctrl-b:preview-page-up,ctrl-f:preview-page-down,ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down,shift-up:preview-top,shift-down:preview-bottom,alt-up:half-page-up,alt-down:half-page-down" 
set -gx FZF_DEFAULT_COMMAND "fd --hidden --type f" 
set -gx FZF_COMPLETION_TRIGGER '~~'

if command -v fzf > /dev/null
    fzf --fish | source
end

if command -v eza > /dev/null
	abbr -a l 'eza'
	abbr -a ls 'eza'
	abbr -a ll 'eza -l'
	abbr -a lll 'eza -la'
else
    # echo "eza not existed"
# 	abbr -a l 'ls'
# 	abbr -a ll 'ls -l'
# 	abbr -a lll 'ls -la'
end

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

# zoxide init fish | source
set -gx VISUAL vim


bind \cx\ce edit_command_buffer


# sh /opt/homebrew/opt/chruby/share/chruby/chruby.sh
# sh /opt/homebrew/opt/chruby/share/chruby/auto.sh
if type -q chruby 
    chruby ruby-3.1.3
end

abbr -a kon ps -ef \| grep ondict \| grep -v grep \| grep -v serve \| awk \'{print \$2}\' \| xargs kill

function glg
    git log --graph --color \
  --format='%C(white)%h - %C(green)%cs - %C(blue)%s%C(red)%d' \
| fzf \
  --ansi \
  --reverse \
  --no-sort \
  --preview='
    echo {} | grep -o "[a-f0-9]\{7\}" \
    && git show --color $(echo {} | grep -o "[a-f0-9]\{7\}")
  '
end

function gco
    # the quote stuff, see https://fishshell.com/docs/current/fish_for_bash_users.html
    # > Fish has two quoting styles: "" and ''. Variables are expanded in double-quotes, nothing is expanded in single-quotes.
    # > There is no $'', instead the sequences that would transform are transformed when unquoted:
    set separator $(printf "\t")
set git_branches "git branch --all --color \
  --format='%(HEAD) %(color:yellow)%(refname:short)$separator%(color:green)%(committerdate:short)$separator%(color:blue)%(subject)' \
  | column -t -s \\t"
eval "$git_branches" \
| fzf \
  --ansi \
  --reverse \
  --no-sort \
  --preview-label='[ Commits ]' \
  --preview='
    git log $(echo {} \
    | sed "s/^[* ]*//" \
    | awk "{print \$1}") \
    --graph --color \
    --format="%C(white)%h - %C(green)%cs - %C(blue)%s%C(red)%d"' \
  --bind='alt-c:execute(
    git checkout $(echo {} \
    | sed "s/^[* ]*//" \
    | awk "{print \$1}")
    )' \
  --bind="alt-c:+reload($git_branches)" \
  --bind='enter:execute(
    set branch $(echo {} \
    | sed "s/^[* ]*//" \
    | awk "{print \$1}") \
    && sh -c "git diff --color $branch \
    | less -R"
    )' \
  --header-first \
  --header '
  > ALT C to checkout the branch
  > ENTER to open the diff with less
  '
end

function colors
    echo -e '\e[1mbold\e[22m'
    echo -e '\e[2mdim\e[22m'
    echo -e '\e[3mitalic\e[23m'
    echo -e '\e[4munderline\e[24m'
    echo -e '\e[4:1mthis is also underline (new in 0.52)\e[4:0m'
    echo -e '\e[21mdouble underline (new in 0.52)\e[24m'
    echo -e '\e[4:2mthis is also double underline (new in 0.52)\e[4:0m'
    echo -e '\e[4:3mcurly underline (new in 0.52)\e[4:0m'
    echo -e '\e[5mblink (new in 0.52)\e[25m'
    echo -e '\e[7mreverse\e[27m'
    echo -e '\e[8minvisible\e[28m <- invisible (but copy-pasteable)'
    echo -e '\e[9mstrikethrough\e[29m'
    echo -e '\e[53moverline (new in 0.52)\e[55m'

    echo -e '\e[31mred\e[39m'
    echo -e '\e[91mbright red\e[39m'
    echo -e '\e[38:5:42m256-color, de jure standard (ITU-T T.416)\e[39m'
    echo -e '\e[38;5;42m256-color, de facto standard (commonly used)\e[39m'
    echo -e '\e[38:2::240:143:104mtruecolor, de jure standard (ITU-T T.416) (new in 0.52)\e[39m'
    echo -e '\e[38:2:240:143:104mtruecolor, rarely used incorrect format (might be removed at some point)\e[39m'
    echo -e '\e[38;2;240;143;104mtruecolor, de facto standard (commonly used)\e[39m'

    echo -e '\e[46mcyan background\e[49m'
    echo -e '\e[106mbright cyan background\e[49m'
    echo -e '\e[48:5:42m256-color background, de jure standard (ITU-T T.416)\e[49m'
    echo -e '\e[48;5;42m256-color background, de facto standard (commonly used)\e[49m'
    echo -e '\e[48:2::240:143:104mtruecolor background, de jure standard (ITU-T T.416) (new in 0.52)\e[49m'
    echo -e '\e[48:2:240:143:104mtruecolor background, rarely used incorrect format (might be removed at some point)\e[49m'
    echo -e '\e[48;2;240;143;104mtruecolor background, de facto standard (commonly used)\e[49m'

    echo -e '\e[21m\e[58:5:42m256-color underline (new in 0.52)\e[59m\e[24m'
    echo -e '\e[21m\e[58;5;42m256-color underline (new in 0.52)\e[59m\e[24m'
    echo -e '\e[4:3m\e[58:2::240:143:104mtruecolor underline (new in 0.52) (*)\e[59m\e[4:0m'
    echo -e '\e[4:3m\e[58:2:240:143:104mtruecolor underline (new in 0.52) (might be removed at some point) (*)\e[59m\e[4:0m'
    echo -e '\e[4:3m\e[58;2;240;143;104mtruecolor underline (new in 0.52) (*)\e[59m\e[4:0m'
end

abbr -a ra ~/Library/Python/3.12/bin/ranger
source ~/local.fish

function find_live_photos --description="find the live photos in my Apple backups"
    set -l path $argv[1]
    for i in (eza $path | grep -i mov)
        set -l name (string split . $i)
        set -l jpg (string join "/" $path $name[1].jpg)
        set -l JPG (string join "/" $path $name[1].JPG)
        if test -f $jpg 
            echo $jpg $i
            else if test -f $JPG
            echo $JPG $i
            else
        end
    end
end

