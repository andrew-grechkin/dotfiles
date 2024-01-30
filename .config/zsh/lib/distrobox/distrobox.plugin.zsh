# vim: filetype=zsh foldmethod=marker

# => alias -------------------------------------------------------------------------------------------------------- {{{1

alias dib='distrobox'
alias dib-images='distrobox --compatibility'

# => main --------------------------------------------------------------------------------------------------------- {{{1

function dib-create-arch () {
	if [[ -r "$HOME/git/private/dotfiles/.local/share/distrobox/resolv.conf" ]]; then
		distrobox-assemble create --file "$HOME/.local/share/distrobox/distrobox-work.ini" -n arch
	else
		distrobox-assemble create --file "$HOME/.local/share/distrobox/distrobox.ini" -n arch
	fi
}
