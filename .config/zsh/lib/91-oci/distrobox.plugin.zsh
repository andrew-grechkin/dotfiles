# vim: filetype=zsh foldmethod=marker

# => alias -------------------------------------------------------------------------------------------------------- {{{1

alias dib='distrobox'
alias dib-images='distrobox --compatibility'

# => main --------------------------------------------------------------------------------------------------------- {{{1

function dib-create-arch () {
	docker build --tag=quay.io/toolbx-images/archlinux-toolbox:latest --file="$HOME/.local/share/distrobox/Dockerfile-arch" .
	distrobox-assemble create --file "$HOME/.local/share/distrobox/distrobox.ini" -n arch
}
