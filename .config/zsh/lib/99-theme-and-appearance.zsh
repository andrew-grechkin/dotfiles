# vim: filetype=zsh foldmethod=marker
# Based on https://github.com/robbyrussell/oh-my-zsh

# => ls colors ---------------------------------------------------------------------------------------------------- {{{1

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

# => man coloring ------------------------------------------------------------------------------------------------- {{{1

# man: termcap
# ke      rmkx      make the keypad send digits
# ks      smkx      make the keypad send commands
# mb      blink     start blink
# md      bold      start bold
# me      sgr0      turn off bold, blink and underline
# mh                enter half-bright mode
# mr                enter reverse-video mode
# se      rmso      stop standout
# so      smso      start standout (reverse video)
# ue      rmul      stop underline
# us      smul      start underline
# vb      flash     emit visual bell

# export LESS_TERMCAP_ZN=$(tput ssubm)
# export LESS_TERMCAP_ZO=$(tput ssupm)
# export LESS_TERMCAP_ZV=$(tput rsubm)
# export LESS_TERMCAP_ZW=$(tput rsupm)
# export LESS_TERMCAP_mb=$(tput bold; tput setaf 2) # green
# export LESS_TERMCAP_md=$(tput bold; tput setaf 6) # cyan
export LESS_TERMCAP_me=$(tput sgr0)
# LESS_TERMCAP_me=$'\e[0m'
# export LESS_TERMCAP_mh=$(tput dim)
# export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
# LESS_TERMCAP_se=$'\e[0m'
# export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) # yellow on blue
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
# LESS_TERMCAP_ue=$'\e[0m'
# export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7) # white
export GROFF_NO_SGR=1

function man() {
	LESS_TERMCAP_us=$'\e[92m'      \
	LESS_TERMCAP_mb=$'\e[5;91m'    \
	LESS_TERMCAP_md=$'\e[1;33m'    \
	LESS_TERMCAP_so=$'\e[1;44;33m' \
	command man "$@"
}
