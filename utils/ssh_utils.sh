ssh_existing_keys() {
	keys="$(ls ~/.ssh/*.pub)"
	if [[ $? != 0 ]]; then
		return 1
	else
		if [[ $keys ]]; then
			echo "$keys"
		else
			return 1
		fi
	fi
}

ssh_generate_new_key() {
	email=$1
	ssh-keygen -t ed25519 -C "$email"
}


ssh_select_and_copy_key() {
	key=$1
	if [[ -z $key ]]; then
		key=$(ssh_existing_keys | fzf --prompt="Select a key> ")
	fi
	cat $key | pbcopy
}
