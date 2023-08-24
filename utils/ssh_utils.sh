ssh_existing_keys() {
	ls ~/.ssh/*.pub || echo ''
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
