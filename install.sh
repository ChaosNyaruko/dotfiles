#!/bin/sh

set -ex
tempDir=$(mktemp -d) 
# echo temp $tempDir

install_thrift_ls() {
    cd $tempDir && git clone https://github.com/joyme123/thrift-ls.git 
    cd thrift-ls && go install .
}

# install language servers by pacakge managers: brew/apt/npm/...
# TODO: adapt to operating systems
install_pkg_ls() {
    go install golang.org/x/tools/gopls@latest
    brew install lua-language-server
    npm install -g pyright
    npm i -g vscode-langservers-extracted
}

install_devel() {
    brew install cmake git wget curl
}

install_tools() {
    exit 2
}

clean() {
    rm -r $tempDir
}

install_package() {
    OSTYPE="$(uname)"
    PACKAGE_NAME="$1"

    if [[ "$OSTYPE" == "Darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install "$PACKAGE_NAME"
        else
            echo "Homebrew is not installed. Please install Homebrew first."
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Debian-based (like Ubuntu)
        if command -v apt &> /dev/null; then
            sudo apt update && sudo apt install -y "$PACKAGE_NAME"
        else
            echo "apt is not available. Please check your distribution."
        fi
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        # Windows (using either winget or scoop)
        if command -v winget &> /dev/null; then
            winget install "$PACKAGE_NAME"
        elif command -v scoop &> /dev/null; then
            scoop install "$PACKAGE_NAME"
        else
            echo "Neither winget nor scoop is installed. Please install one of them."
        fi
    elif [[ "$OSTYPE" == "linux-android"* ]]; then
        # Arch Linux
        if command -v pacman &> /dev/null; then
            sudo pacman -Syu "$PACKAGE_NAME"
        else
            echo "pacman is not available. Please check your installation."
        fi
    else
        echo "Unsupported OS: $OSTYPE"
    fi
}

install_package "$1"
