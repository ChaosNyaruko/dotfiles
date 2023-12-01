#!/bin/bash

DOTFILEREPO="$HOME/dotfiles"
echo "$DOTFILEREPO"

show() {
    GLOBIGNORE=".:.."
    # shopt -u dotglob
    # echo * # all (only non-hidden)
    # echo .* # all (only hidden)
    shopt -s dotglob
    echo "existing bak files:"
    ls -l ~/.*bak*
    ls -l ~/.config/nvim/*bak*

}

clean() {
    echo -n "cleaning..."
    rm ~/*bak*
    rm ~/.config/nvim/*bak*
    echo "clean over"
}


clone() {
    echo -e "removing repo $DOTFILEREPO...\n\n"
    rm -rf $DOTFILEREPO
    git clone git@github.com:ChaosNyaruko/dotfiles.git $DOTFILEREPO
    if [[ $? -ne 0 ]]; then
        echo "git clone err, exit"
        exit 1
    fi
}

help() {
    echo -e "--show: show removing files\n--clean: cleaing files\n--build: build dotfiles\n--help: show this help"
}

if [[ $1 == "--clean" ]] || [[ $1 == "-c" ]]; then 
    echo "show and clean..."
    show
    clean
    exit 0
elif [[ $1 == "--list" ]] || [[ $1 == "-l" ]]; then 
    echo "show removing files"
    show
    exit 0
elif [[ $1 == "--all" ]] || [[ $1 == "-a" ]]; then
    MODE=all
    echo "building dotfiles..."
elif [[ $1 == "--screen" ]] || [[ $1 == "-s" ]]; then
    MODE=screen
    echo "building .screenrc..."
elif [[ $1 == "--git" ]] || [[ $1 == "-g" ]]; then
    MODE=git
    echo "building .screenrc..."
else 
    echo -ne "unsupported usage\n"
    help
    exit 0
fi

VIMRCFILE=$HOME/.vimrc
NVIMFILE=$HOME/.config/nvim
TMUXCONF=$HOME/.tmux.conf
SCREENRC=$HOME/.screenrc
GITCONFIG=$HOME/.gitconfig

if [ $MODE == "all" ]; then
    FILES=($VIMRCFILE $NVIMFILE $TMUXCONF)
elif [ $MODE == "screen" ]; then
    FILES=($SCREENRC)
elif [ $MODE == "git" ]; then
    FILES=($GITCONFIG)
fi
# echo "$FILES" # TODO: only print one? weird, learn it later.
for file in ${FILES[@]}; do
    # determine actually dotfile
    echo "file:$file"
done

echo -e "\n\n\n"

show
echo -e "\n\n\n"
clean
echo -e "\n\n\n"
clone
echo -e "\n\n\n"

echo "rebuilding dotfiles......"
for file in ${FILES[@]}; do
    # determine actually dotfile
    DEST=""
    if [[ "$file" == "$VIMRCFILE" ]]; then
        DEST="$DOTFILEREPO/vimrc"
    elif [[ "$file" == "$NVIMFILE" ]]; then
        DEST="$DOTFILEREPO/nvim"
    elif [[ "$file" == "$TMUXCONF" ]]; then
        DEST="$DOTFILEREPO/tmux.conf"
    elif [[ "$file" == "$SCREENRC" ]]; then
        DEST="$DOTFILEREPO/screenrc"
    elif [[ "$file" == "$GITCONFIG" ]]; then
        DEST="$DOTFILEREPO/gitconfig"
    else
        echo "error"
        exit 1
    fi
    echo "file: $file, DEST:$DEST"

    if [ -L "$file" ] || [ -f "$file" ]; then 
        # echo  "$file exists\n"
        t=$(date "+%Y%m%d_%H%M%S")
        bakup=${file}"_bak"${t} 
        echo "baking up $bakup"
        cp $file $bakup
        rm $file
        echo  "$file exists, remove it"
    else
        echo  "$file does not exist, creating new one"
    fi
    # echo  "dest: $DEST, sym: $file"
    ln -s $DEST $file && echo "set link to dotfiles: $file->$DEST"
    echo -e "\n\n\n"
done

