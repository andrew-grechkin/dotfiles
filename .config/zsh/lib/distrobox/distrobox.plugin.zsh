# vim: filetype=zsh foldmethod=marker

# => alias -------------------------------------------------------------------------------------------------------- {{{1

alias dib='distrobox'
alias dib-images='distrobox --compatibility'

# => main --------------------------------------------------------------------------------------------------------- {{{1

function dib-create-arch () {
	distrobox-assemble create --file "$HOME/.local/share/distrobox/distrobox.ini" -n arch
}
