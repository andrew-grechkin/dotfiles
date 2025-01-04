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
