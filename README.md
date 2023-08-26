# Dotfiles

This is my collection of dotfiles for quickly
getting my Dev Env up and running on a new macbook

## Instalation

### From scratch
Meant to be run off a brand new macbook
It doesn't need to have any dependencies installed
not git, homebrew, anything.
```
cd ~ && curl https://raw.githubusercontent.com/bhugovilela/dotfiles/main/bootstrap.sh | zsh

```
This will download the bootstrap.sh script and execute it

### From Git
1. cd ~ 
2. Clone the repository
3. run `bootstrap.sh`

## TODO
- vscode settings
- iTerm2 settings

## What does it do?
- Installs:
    - xcode-select command line utils
    - Homebrew
    - Git
    - other cmd line utils (stow, ripgrep, fzf, nvm)
    - neovim
    - iTerm2
    - Sourcetree
    - vscode
    - openvpn connect
    - Docker
    - ms teams
    - chrome
    - vlc
    - calibre
    - transmission
    - node
- Configures dotfiles (symlink using stow)
    - stow/.config/* into ~/.config
    - stow/home/* into ~
    - stow/home/* into ~
- Installs custom scripts (symlink using stow)
    - stow/custom_scripts into ~/.local/bin
    - adds ~/.local/bin to $PATH
- Configures ssh

