# Quick Start

Download and run setup:

```bash
wget https://raw.githubusercontent.com/ChaosNyaruko/dotfiles/main/setup.sh
chmod +x ./setup.sh
```

## Personal PC

Symlink tmux, neovim, gitconfig, fish, alacritty, bins, and `.vimrc`:

```bash
./setup.sh pc
```

## Remote Server

Install tmux, download [z.sh](https://github.com/rupa/z), symlink tmux config, and add z to `~/.bashrc`:

```bash
./setup.sh server
```

Server mode may require `sudo` to install tmux via the system package manager.

## Environment

Override the default repo path if needed:

```bash
DOTFILEREPO=~/my-dotfiles ./setup.sh pc
```

## Optional Commands

```bash
./setup.sh --list    # list backup files
./setup.sh --clean   # remove backup files (*_bak*)
./setup.sh --share   # copy share/* to ~/.local/share/
./setup.sh help      # show usage
```

## Notes

For neovim settings, basic tools might be needed such as fzf/git/cmake/curl/...

Check the error log if some of the installation failed.

# Brewfile

```bash
brew bundle dump
```

`brew bundle --help` for more details.
