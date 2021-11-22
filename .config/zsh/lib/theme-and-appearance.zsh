# vim: filetype=zsh foldmethod=marker
# Based on https://github.com/robbyrussell/oh-my-zsh

# => Colors configuration ---------------------------------------------------------------------------------------- {{{1

setopt MULTIOS
setopt PROMPT_SUBST

# => ls colors --------------------------------------------------------------------------------------------------- {{{1

autoload -U colors && colors

if [[ "$DISABLE_LS_COLORS" != "true" ]]; then
	# For GNU ls, we use the default ls color theme. They can later be overwritten by themes.
	if [[ -z "$LS_COLORS" ]] && (( $+commands[dircolors] )); then
		eval "$(dircolors -b ~/.config/shell/dircolors.conf)"
	fi

	ls --color -d . &>/dev/null && alias ls='ls --color=tty' || { ls -G . &>/dev/null && alias ls='ls -G' }

	# Take advantage of $LS_COLORS for completion as well.
	zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

# => man coloring ------------------------------------------------------------------------------------------------ {{{1

function man() {
	LESS_TERMCAP_mb=$'\e[01;31m' \
	LESS_TERMCAP_md=$'\e[01;33m' \
	LESS_TERMCAP_me=$'\e[0m' \
	LESS_TERMCAP_so=$'\e[01;44;33m' \
	LESS_TERMCAP_se=$'\e[0m' \
	LESS_TERMCAP_us=$'\e[01;32m' \
	LESS_TERMCAP_ue=$'\e[0m' \
	command man "$@"
}
