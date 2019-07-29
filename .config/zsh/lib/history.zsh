# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

# => environment -------------------------------------------------------------------------------------------------- {{{1

export HISTORY_IGNORE='(exit( *)#|history( *)#|[bf]g *|cd *|l[alsh] *|less *|kill *|vi *|vim *)'

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

if [[ -n "$HOSTNAME" ]] && [[ -n "$XDG_STATE_HOME" ]]; then
	HISTFILE_DIR="$XDG_STATE_HOME/zsh"
	mkdir -p "$HISTFILE_DIR" &>/dev/null

	HISTFILE="$HISTFILE_DIR/history@${HOSTNAME}"
	HISTFILE_BAK="${HISTFILE}.bak"

	if [[ -r "$HISTFILE" ]]; then
		HF_SIZE=$(stat -c%s "$HISTFILE")
	else
		HF_SIZE=0
	fi

	if [[ -r "$HISTFILE_BAK" ]]; then
		BF_SIZE=$(stat -c%s "$HISTFILE_BAK")
	else
		BF_SIZE=0
	fi

	if (( HF_SIZE < 20000 && 30000 < BF_SIZE)); then
		echo 'History file is lower than 20 kbytes, restoring backup...'
		cp -f "$HISTFILE_BAK" "$HISTFILE"
	elif (( HF_SIZE > 10000 && HF_SIZE > BF_SIZE)); then
		cp -f "$HISTFILE" "$HISTFILE_BAK"
	fi

	export HISTFILE
else
	echo 'HOSTNAME is undefined, HISTFILE is a default value' &>/dev/stderr
fi

# => alias -------------------------------------------------------------------------------------------------------- {{{1

alias h='history'
# alias crap='history -d $((HISTCMD-1))'

# => helper ------------------------------------------------------------------------------------------------------- {{{1

# do not save command in history if executable cannot be run
function zshaddhistory() {
	# not working if environment is passed as the first word in command
	# EXECUTABLE="${${(z)1}[1]}"
	# whence "$EXECUTABLE" >| /dev/null || return 2
	[[ "$1" =~ "^ " ]] && return 2
	TRIMMED=$(perl -XE 'print (<> =~ s/(\s | \R | (\\n))+$ | ^(\\n)+//rgnxms)' <<< "$1")
	print -Sr -- "$TRIMMED"
	return 1
}

function h-disable() {
	HF="$HISTFILE"
	fc -p "${XDG_RUNTIME_DIR}/temp-hist" "${HISTSIZE}" "${SAVEHIST}"
	fc -R "$HF"

	add-zsh-hook -d precmd _atuin_precmd
	add-zsh-hook -d preexec _atuin_preexec
}

function h-reduce() {
	HF="$HISTFILE"
	fc -pa "${XDG_RUNTIME_DIR}/temp-hist" "${HISTSIZE}" "${SAVEHIST}"
	fc -R "$HF"
	h-filter-and-delete
}

function h-trimmed() {
	fc -l -n 0 | perl -lpXE 's/(\s | (\\n))+$ | ^(\s | (\\n))+//gnx'
}
