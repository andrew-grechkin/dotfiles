# vim: filetype=zsh foldmethod=marker

# => alias -------------------------------------------------------------------------------------------------------- {{{1

alias dib='distrobox'
alias dib-images='distrobox --compatibility'

# => main --------------------------------------------------------------------------------------------------------- {{{1

function dib-create-arch () {
	docker build --tag=quay.io/toolbx-images/archlinux-toolbox:latest --file="$HOME/.local/share/distrobox/archlinux-toolbox.Dockerfile" .
	distrobox-assemble create --file "$HOME/.local/share/distrobox/distrobox.ini" -n arch
}

function dib-create-ubuntu16 () {
	distrobox-assemble create --file "$HOME/.local/share/distrobox/distrobox.ini" -n ubuntu16
}
