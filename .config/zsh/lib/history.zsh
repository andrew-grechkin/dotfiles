# vim: filetype=zsh foldmethod=marker

# => History file configuration ----------------------------------------------------------------------------------- {{{1

HISTSIZE=655350
SAVEHIST=655350

# => History command configuration https://zsh.sourceforge.io/Doc/Release/Options.html#History -------------------- {{{1

# man: zshoptions

setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_ALL_DUPS                                                    # ignore duplicated commands history list
setopt HIST_IGNORE_SPACE                                                       # ignore commands that start with space
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_BY_COPY
setopt HIST_VERIFY                                                             # show command with history expansion to user before running it
setopt INC_APPEND_HISTORY

if [[ -r "$HISTFILE" ]]; then
	if (( $(stat -c%s "$HISTFILE") < 10000 )); then
		[[ -r "${HISTFILE}.back" ]] && {
			echo 'History file is lower than 10 kbytes, restoring backup...'
			cp -f "${HISTFILE}.back" "$HISTFILE"
		}
	else
		cp -f "$HISTFILE" "${HISTFILE}.back"
	fi
fi

# => alias -------------------------------------------------------------------------------------------------------- {{{1

alias h='history'
alias h-disable='HF="$HISTFILE"; fc -p "${XDG_RUNTIME_DIR}/temp-hist" "${HISTSIZE}" "${SAVEHIST}"; fc -R "$HF"'
# alias crap='history -d $((HISTCMD-1))'

# => helper ------------------------------------------------------------------------------------------------------- {{{1

# do not save command in history if executable cannot be run
function zshaddhistory() {
	EXECUTABLE="${${(z)1}[1]}"
	whence "$EXECUTABLE" >| /dev/null || return 2
}
