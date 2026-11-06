# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

autoload -U colors && colors

if [[ "$DISABLE_LS_COLORS" != "true" ]]; then
	# For GNU ls use the default ls color theme. They can later be overwritten by themes.
	if [[ -z "$LS_COLORS" ]] && (( $+commands[dircolors] )); then
		eval "$(dircolors -b ~/.config/shell/dircolors.conf)"
	fi

	ls --color -d . &>/dev/null && alias ls='ls --color=tty' || { ls -G . &>/dev/null && alias ls='ls -G' }

	# Take advantage of $LS_COLORS for completion as well.
	zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi
