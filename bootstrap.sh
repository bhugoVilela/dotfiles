#!/usr/bin/env zsh

CUSTOM_SCRIPTS_TARGET="$HOME/.local/bin"
NVM_DIR="$HOME/.nvm"

[[ -f  "./utils/ssh_utils.sh" ]] && source './utils/ssh_utils.sh'

download_repo_if_needed() {
	if [[ -d ".git" ]]; then
		return 0
	fi
	# download git repository
	curl -LJO https://github.com/bhugovilela/dotfiles/archive/main.zip --output main.zip
	unzip ./dotfiles-main.zip
	mv ./dotfiles-main ./.dotfiles
	cd ./.dotfiles
	rm ../dotfiles-main.zip
	[[ -f  "./utils/ssh_utils.sh" ]] && source './utils/ssh_utils.sh'
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
	mkdir ~/.config || echo ""
	_echo "stowing .config"
	stow --dir=./stow --target=$HOME/.config .config
	_echo 'stowing $HOME dotfiles'
	stow --dir=./stow --target=$HOME home
}

install_custom_scripts() {
	_echo "stowing custom scripts"
	stow --dir=./stow --target="$CUSTOM_SCRIPTS_TARGET" custom_scripts
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

	_echo "adding Homebrew to path"
	[[ -f "$HOME/.zprofile" ]] || touch "$HOME/.zprofile"
	(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> "$HOME/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"

	_echo "running brew bundle"
	brew bundle || echo "Brew finished with some errors"
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
	  mkdir -pv "${HOME}/.local/bin" || echo ""
	fi
	reload_path
}

setup_nvm() {
	mkdir ~/.nvm
	nvm install node
}

setup_neovim() {
	_echo "running fzf installation script..."
	$(brew --prefix)/opt/fzf/install

	_echo "installing Packer..."
	git clone https://github.com/wbthomason/packer.nvim\
 	~/.local/share/nvim/site/pack/packer/opt/packer.nvim

	reload_path
	_echo "NeoVim installation finished. Don't forget to run PackerSync on first boot"
}

install_xcode_cmd_line_tools() {
	_echo "installing xcode command line tools..."
	xcode-select --install || _echo "Already installed"
	read -k 1 "Installing xcode-select... Press any key once finished"
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
	read -k 1 "Installing xcode-select... Press any key once finished"
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

