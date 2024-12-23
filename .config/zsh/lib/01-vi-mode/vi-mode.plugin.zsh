# vim: filetype=sh foldmethod=marker

# bindkey -l
# bindkey -M main
# bindkey
#
#key=(
#    Home     "${terminfo[khome]}"
#    End      "${terminfo[kend]}"
#    Insert   "${terminfo[kich1]}"
#    Delete   "${terminfo[kdch1]}"
#    Up       "${terminfo[kcuu1]}"
#    Down     "${terminfo[kcud1]}"
#    Left     "${terminfo[kcub1]}"
#    Right    "${terminfo[kcuf1]}"
#    PageUp   "${terminfo[kpp]}"
#    PageDown "${terminfo[knp]}"
#    BackTab  "${terminfo[kcbt]}"
#)

# => Updates editor information when the keymap changes ----------------------------------------------------------- {{{1

function zle-keymap-select() {
	zle reset-prompt
	zle -R
}

# => Ensure that the prompt is redrawn when the terminal size changes --------------------------------------------- {{{1

function TRAPWINCH() {
	zle && zle-keymap-select
}

zle -N zle-keymap-select
zle -N edit-command-line

# => vi mode ------------------------------------------------------------------------------------------------------ {{{1

bindkey -v

# => remove Ctrl-j binding (i think it's not safe to have it, accept should be only by pressing Enter) ------------ {{{1

bindkey -r '^j'

# => v to edit the command line ----------------------------------------------------------------------------------- {{{1

autoload -Uz edit-command-line
bindkey -M vicmd 'v'    edit-command-line

# => Arrow-Up, Arrow-Down ----------------------------------------------------------------------------------------- {{{1

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey          '^P'   up-line-or-beginning-search
bindkey          '^N'   down-line-or-beginning-search

# standard bindings are overriden
#bindkey          '^P'   up-line-or-history
#bindkey          '^N'   down-line-or-history

[[ -n "${terminfo[kcuu1]}" ]] && bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
[[ -n "${terminfo[kcud1]}" ]] && bindkey "${terminfo[kcud1]}" down-line-or-beginning-search

# => ctrl-r, ctrl-s to perform search in history ------------------------------------------------------------------ {{{1

bindkey          '^R'   history-incremental-search-backward
bindkey -M vicmd '^R'   history-incremental-search-backward
bindkey          '^S'   history-incremental-search-forward
bindkey          '^O'   accept-line-and-down-history

# => ctrl-d, ctrl-h, ctrl-?, ctrl-w for char and word deletion ---------------------------------------------------- {{{1

bindkey          '^D'   delete-char-or-list
bindkey -M vicmd '^D'   delete-char-or-list
bindkey          '^H'      backward-delete-char
bindkey -M vicmd '^H'   vi-backward-delete-char
bindkey          '^?'      backward-delete-char
bindkey -M vicmd '^?'   vi-backward-delete-char
bindkey          '^W'      backward-kill-word
bindkey -M vicmd '^W'   vi-backward-kill-word

# => ctrl-b and ctrl-f to move cursor left and right -------------------------------------------------------------- {{{1

bindkey          '^B'   backward-char
bindkey -M vicmd '^B'   backward-char
bindkey          '^F'   forward-char
bindkey -M vicmd '^F'   forward-char

# => Home, End, ctrl-a and ctrl-e to move to beginning/end of line ------------------------------------------------ {{{1

if [[ "${terminfo[khome]}" != "" ]]; then
	bindkey "${terminfo[khome]}"             beginning-of-line
	bindkey -M vicmd "${terminfo[khome]}" vi-beginning-of-line
fi
if [[ "${terminfo[kend]}" != "" ]]; then
	bindkey "${terminfo[kend]}"              end-of-line
	bindkey -M vicmd "${terminfo[kend]}"  vi-end-of-line
fi
bindkey          '^A'      beginning-of-line
bindkey -M vicmd '^A'   vi-beginning-of-line
bindkey          '^E'      end-of-line
bindkey -M vicmd '^E'   vi-end-of-line

# => PageUp, PageDown as home and end ----------------------------------------------------------------------------- {{{1

if [[ "${terminfo[kpp]}" != "" ]]; then
	bindkey          "${terminfo[kpp]}"    beginning-of-line
	bindkey -M vicmd "${terminfo[kpp]}" vi-beginning-of-line
fi
if [[ "${terminfo[knp]}" != "" ]]; then
	bindkey          "${terminfo[knp]}"    end-of-line
	bindkey -M vicmd "${terminfo[knp]}" vi-end-of-line
fi

# => Insert, Delete ----------------------------------------------------------------------------------------------- {{{1

if [[ "${terminfo[kich1]}" != "" ]]; then
	bindkey          "${terminfo[kich1]}" overwrite-mode
	bindkey -M vicmd "${terminfo[kich1]}" vi-insert
fi
if [[ "${terminfo[kdch1]}" != "" ]]; then
	bindkey          "${terminfo[kdch1]}" delete-char-or-list
	bindkey -M vicmd "${terminfo[kdch1]}" delete-char-or-list
fi

# => some backports from emacs key bindings ----------------------------------------------------------------------- {{{1

bindkey          '^K'   kill-line
bindkey -M vicmd '^K'   kill-line
bindkey          '^U'   backward-kill-line
bindkey -M vicmd '^U'   backward-kill-line
bindkey          '^Y'   yank
bindkey -M vicmd '^Y'   yank
# conflicts with fzf
#bindkey          '^t'   transpose-chars
bindkey          '\eb'  backward-word
bindkey          '\ef'  forward-word
bindkey -M vicmd '\ef'  vi-forward-word
bindkey          '\ed'  kill-word
bindkey -M vicmd '\ed'  kill-word
bindkey          '\et'  transpose-words
bindkey -M vicmd '\et'  transpose-words
bindkey          '^Xu'  vi-join
bindkey          '^Xu'  undo
bindkey          '^Xv'  edit-command-line
bindkey          '^X^E' edit-command-line

# => Mode indicator ----------------------------------------------------------------------------------------------- {{{1

# if mode indicator wasn't setup by theme, define default
if [[ "$MODE_INDICATOR" == "" ]]; then
	MODE_INDICATOR="%{$fg_bold[red]%}<%{$fg[red]%}<<%{$reset_color%}"
fi

function vi_mode_prompt_info() {
	KEYMAP="${KEYMAP:-}"
	echo "${${KEYMAP/vicmd/$MODE_INDICATOR}/(main|viins)/}"
}

# define right prompt, if it wasn't defined by a theme
if [[ "$RPS1" == "" && "$RPROMPT" == "" ]]; then
	RPS1='$(vi_mode_prompt_info)'
fi
