#!/usr/bin/env bash

CUSTOM_SCRIPTS_TARGET="$HOME/.local/bin"
NVM_DIR="$HOME/.nvm"

download_repo_if_needed() {
	if [[ -d ".git" ]]; then
		source ./utils/ssh_utils.sh
		return 0
	fi
	# download git repository
	wget https://github.com/bhugovilela/dotfiles/archive/main.zip
	unzip main.zip
	cd ./dotfiles-main
	rm main.zip
	source ./utils/ssh_utils.sh
}

_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\\n[DOTFILES] ${fmt}\\n" "$@"
}

reload_path() {
	if [[ -f ~/.zshrc ]]; then
		_echo "Reloading ~/.zshrc..."
		source ~/.zshrc
	fi
}

# creates symlinks
install_dotfiles() {
	mkdir ~/.config
	_echo "stowing .config"
	stow --dir=./stow --target=$HOME/.config .config
	_echo 'stowing $HOME dotfiles'
	stow --dir=./stow --target=$HOME home
	_echo 'stowing custom scripts'
	stow --dir=./stow --target=$CUSTOM_SCRIPTS_TARGET custom_scripts
}

install_custom_scripts() {
	_echo "stowing custom scripts"
	stow --dir=./stow --target=/usr/local/bin custom_scripts
}

configure_ssh() {
	_echo "Configuring SSH..."
	keys="$(ssh_existing_keys)"
	if [[ $keys ]]; then
		_echo "Some SSH keys already exist:"
		echo "$keys"
		_echo "What do you want to do?"
		echo "Use an existing key (a)"
		echo "Generate a new key (b)"
		echo "Cancel (c)"
		read -k 1 option

		case "$option" in
			"a")
				ssh_select_and_copy_key
			;;
			"b")
				ssh_generate_new_key
				ssh_select_and_copy_key
			;;
			"c")
				_echo "aborted"
				return 0
			;;
		esac
	else
		_echo "No SSH keys exist"
		_echo "What do you want to do?"
		echo "Generate a new key (a)"
		echo "Cancel (c)"
		read -k 1 option

		case "$option" in
			"a")
				ssh_generate_new_key
				ssh_select_and_copy_key
			;;
			"c")
				_echo "aborted"
				return 0
			;;
		esac
	fi
	_echo "The public key's contents have been copied to the clipboard. Go to github.com and add it to your account"
	_echo "once done, press any key to continue"
	read -k 1 option
}

configure_zsh() {
	_echo "installing oh my zsh..."
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

	cat ~/.zshrc | grep ". ~/zshrc-extras" >/dev/null
	if [ $? -ne 0 ]; then
		_echo "Adding .zshrc-extras to .zshrc"
		echo "\n. ~/.zshrc-extras\n" >> ~/.zshrc
	else
		_echo ".zshrc-extras was already added to .zshrc"
	fi
	reload_path
}

configure_bash() {
	cat ~/.bashrc | grep ". ~/bashrc-extras" >/dev/null
	if [ $? -ne 0 ]; then
		_echo "Adding .bashrc-extras to .bashrc"
		echo "\n. ~/.bashrc-extras\n" >> ~/.zshrc
	else
		_echo ".bashrc-extras was already added to .bashrc"
	fi
}

setup_brew() {
	_echo "installing Homebrew"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	_echo "running brew bundle"
	brew bundle
	reload_path
}

assert_os() {
	osname=$(uname)

	if [ "$osname" != "Darwin" ]; then
	  _echo "Oops, it looks like you're using a non-Apple system. Sorry, this script only supports macOS. Exiting..."
	  exit 1
	fi
}

setup_XDG_CONFIG_HOME() {
	if [ -z "$XDG_CONFIG_HOME" ]; then
	  _echo "Setting up ~/.config directory..."
	  if [ ! -d "${HOME}/.config" ]; then
		mkdir "${HOME}/.config"
	  fi
	  export XDG_CONFIG_HOME="${HOME}/.config"
	fi
}

setup_local_bin() {
	echo "here1"
	if [ ! -d "${HOME}/.local/bin" ]; then
	  _echo "Setting up ~/.local/bin directory..."
	  mkdir -pv "${HOME}/.local/bin"
	fi
	reload_path
}

setup_nvm() {
	echo "here2"
	mkdir ~/.nvm
}

setup_neovim() {
	_echo "running fzf installation script..."
	$(brew --prefix)/opt/fzf/install
	reload_path
}

assert_os
sudo -v

if [[ "$1" = 'dry' ]]; then
	_echo "DRY RUN. No installation was performed"
	setup_local_bin
	setup_nvm
else
	# MAIN
	set -e # exits script if any function returns non 0
	xcode-select --install
	download_repo_if_needed
	setup_XDG_CONFIG_HOME
	setup_local_bin
	setup_brew
	configure_zsh
	configure_bash
	install_dotfiles
	setup_nvm
	setup_neovim
	install_custom_scripts
	configure_ssh
fi

