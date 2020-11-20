# vim: foldmethod=marker

# => pacman ------------------------------------------------------------------------------------------------------ {{{1

function arch-list-altered-files() {
	sudo pacman -Qkkq
}

function arch-remove-orphans() {
	sudo pacman -Rns $(pacman -Qtdq)
}

function arch-update() {
	trizen -Syu --noconfirm --noedit --needed
}

function arch-mirrors-update() {
	sudo reflector --country Netherlands --latest 8 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist
}

# => pacman + fzf ------------------------------------------------------------------------------------------------ {{{1

function arch-install() {
	pacman -Slq \
	| fzf --multi --preview 'cat <(pacman -Si {1}) <(pacman -Fl {1} | awk "{print \$2}")' \
	| xargs -ro sudo pacman -S
}

function arch-remove() {
	pacman -Qq \
	| fzf --multi --preview "pacman -Qi {1}" \
	| xargs -ro sudo pacman -Rns
}
