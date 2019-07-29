# vim: foldmethod=marker

# => pacman ------------------------------------------------------------------------------------------------------- {{{1

function arch-list-altered-files() {
	sudo pacman -Qkkq
}

function arch-update() {
	#export all_proxy='http://vdsm.ams:8888'
	#export http_proxy='http://vdsm.ams:8888'
	trizen -Syu --noconfirm --noedit --needed \
		&& sudo pacman -Fy
}

function arch-mirrors-update() {
	sudo reflector --country Netherlands --latest 8 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist
}

function arch-upgrade() {
	pushd ~/git/private/ansible-arch &>/dev/null
	ansible-playbook playbooks/upgrade.yaml --connection=local -i localhost, -K
	# ansible-playbook playbooks/upgrade.yaml -i hosts -l arch -K
	popd &>/dev/null
}

function arch-upgrade-all() {
	pushd ~/git/private/ansible-arch &>/dev/null
	ansible-playbook playbooks/upgrade.yaml -i hosts.yaml -K --ask-vault-pass
	popd &>/dev/null
}

# => pacman + fzf ------------------------------------------------------------------------------------------------- {{{1

function arch-install() {
	pacman -Slq \
	| fzf --reverse --multi --bind 'tab:toggle-out,shift-tab:toggle-in' --preview 'cat <(pacman -Si {1}) <(pacman -Fl {1} | awk "{print \$2}")' \
	| xargs -ro sudo pacman -S
}

function arch-remove() {
	pacman -Qqe \
	| fzf --reverse --multi --bind 'tab:toggle-out,shift-tab:toggle-in' --preview "pacman -Qi {1}" \
	| xargs -ro sudo pacman -Rns
}
