# vim: syntax=zsh foldmethod=marker

# => Updates editor information when the keymap changes ---------------------------------------------------------- {{{1

function zle-keymap-select() {
	zle reset-prompt
	zle -R
}

# => Ensure that the prompt is redrawn when the terminal size changes -------------------------------------------- {{{1

TRAPWINCH() {
	zle && zle-keymap-select
}

zle -N zle-keymap-select
zle -N edit-command-line

# => vi mode ----------------------------------------------------------------------------------------------------- {{{1

bindkey -v

# => remove Ctrl-j binding (i think it's not safe to have it, accept should be only by pressing Enter) ----------- {{{1

bindkey -r '^j'

# => v to edit the command line ---------------------------------------------------------------------------------- {{{1

autoload -Uz edit-command-line
bindkey -M vicmd 'v'    edit-command-line

# => Arrow-Up, Arrow-Down ---------------------------------------------------------------------------------------- {{{1

if [[ "${terminfo[kcuu1]}" != "" ]]; then
	autoload -U up-line-or-beginning-search
	zle -N up-line-or-beginning-search
	bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
fi
if [[ "${terminfo[kcud1]}" != "" ]]; then
	autoload -U down-line-or-beginning-search
	zle -N down-line-or-beginning-search
	bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
fi

# => ctrl-p, ctrl-n, ctrl-o for navigate history ----------------------------------------------------------------- {{{1

bindkey          '^p'   up-line-or-history
bindkey          '^n'   down-line-or-history
bindkey          '^o'   accept-line-and-down-history
bindkey          '^s'   history-incremental-search-forward

# => ctrl-h, ctrl-w, ctrl-? for char and word deletion ----------------------------------------------------------- {{{1

bindkey          '^d'   delete-char-or-list
bindkey          '^h'   backward-delete-char
bindkey          '^w'   backward-kill-word
bindkey -M vicmd '^d'   delete-char-or-list
bindkey -M vicmd '^h'   vi-backward-delete-char
bindkey -M vicmd '^w'   vi-backward-kill-word

# => ctrl-r to perform backward search in history ---------------------------------------------------------------- {{{1

bindkey          '^r'   history-incremental-search-backward
bindkey -M vicmd '^r'   history-incremental-search-backward

# => ctrl-b and ctrl-f to move cursor left and right ------------------------------------------------------------- {{{1

bindkey          '^b'   backward-char
bindkey          '^f'   forward-char
bindkey -M vicmd '^b'   backward-char
bindkey -M vicmd '^f'   forward-char

# => Home, End, ctrl-a and ctrl-e to move to beginning/end of line ----------------------------------------------- {{{1


if [[ "${terminfo[khome]}" != "" ]]; then
	bindkey "${terminfo[khome]}"             beginning-of-line
	bindkey -M vicmd "${terminfo[khome]}" vi-beginning-of-line
fi
if [[ "${terminfo[kend]}" != "" ]]; then
	bindkey "${terminfo[kend]}"             end-of-line
	bindkey -M vicmd "${terminfo[kend]}" vi-end-of-line
fi
bindkey          '^a'    beginning-of-line
bindkey          '^e'    end-of-line
bindkey -M vicmd '^a' vi-beginning-of-line
bindkey -M vicmd '^e' vi-end-of-line

# => some backports from emacs key bindings ---------------------------------------------------------------------- {{{1

bindkey          '^k'   kill-line
bindkey -M vicmd '^k'   kill-line
bindkey          '^u'   backward-kill-line
bindkey -M vicmd '^u'   backward-kill-line
bindkey          '^t'   transpose-chars
bindkey          '\eb'  backward-word
bindkey          '\ef'  forward-word
bindkey -M vicmd '\ef'  vi-forward-word
bindkey          '\ed'  kill-word
bindkey -M vicmd '\ed'  kill-word
bindkey          '\et'  transpose-words
bindkey          '^x^e' edit-command-line
bindkey          '^xu'  undo

# => Insert, Delete ---------------------------------------------------------------------------------------------- {{{1

if [[ "${terminfo[kich1]}" != "" ]]; then
	bindkey          "${terminfo[kich1]}" overwrite-mode
	bindkey -M vicmd "${terminfo[kich1]}" vi-insert
fi
if [[ "${terminfo[kdch1]}" != "" ]]; then
	bindkey          "${terminfo[kdch1]}" delete-char-or-list
	bindkey -M vicmd "${terminfo[kdch1]}" delete-char-or-list
fi

# => Mode indicator ---------------------------------------------------------------------------------------------- {{{1

# if mode indicator wasn't setup by theme, define default
if [[ "$MODE_INDICATOR" == "" ]]; then
	MODE_INDICATOR="%{$fg_bold[red]%}<%{$fg[red]%}<<%{$reset_color%}"
fi

function vi_mode_prompt_info() {
	echo "${${KEYMAP/vicmd/$MODE_INDICATOR}/(main|viins)/}"
}

# define right prompt, if it wasn't defined by a theme
if [[ "$RPS1" == "" && "$RPROMPT" == "" ]]; then
	RPS1='$(vi_mode_prompt_info)'
fi
