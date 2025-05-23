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

function define_histfile() {
	if [[ -n "$HOSTNAME" ]] && [[ -n "$XDG_STATE_HOME" ]]; then
		local histfile_dir="$XDG_STATE_HOME/zsh"
		mkdir -p "$histfile_dir" &>/dev/null

		HISTFILE="$histfile_dir/history@${HOSTNAME}"
		local histfile_bak="${HISTFILE}.bak"

		if [[ -r "$HISTFILE" ]]; then
			local hf_size=$(stat -c%s "$HISTFILE")
		else
			local hf_size=0
		fi

		if [[ -r "$histfile_bak" ]]; then
			local bf_size=$(stat -c%s "$histfile_bak")
		else
			local bf_size=0
		fi

		if (( hf_size < 20000 && 30000 < bf_size)); then
			echo 'History file is lower than 20 kbytes, restoring backup...'
			cp -f "$histfile_bak" "$HISTFILE"
		elif (( hf_size > 10000 && hf_size > bf_size)); then
			cp -f "$HISTFILE" "$histfile_bak"
		fi

		export HISTFILE
	else
		echo 'HOSTNAME is undefined, HISTFILE is a default value' >&2
	fi
}
define_histfile
unset define_histfile

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
	local trimmed=$(perl -XE 'print (<> =~ s/(\s | \R | (\\n))+$ | ^(\\n)+//rgnxms)' <<< "$1")
	print -Sr -- "$trimmed"
	return 1
}

function h-disable() {
	local hf="$HISTFILE"
	fc -p "${XDG_RUNTIME_DIR}/temp-hist" "${HISTSIZE}" "${SAVEHIST}"
	fc -R "$hf"

	# add-zsh-hook -d precmd _atuin_precmd
	# add-zsh-hook -d preexec _atuin_preexec
}

function h-reduce() {
	local hf="$HISTFILE"
	fc -pa "${XDG_RUNTIME_DIR}/temp-hist" "${HISTSIZE}" "${SAVEHIST}"
	fc -R "$hf"
	h-filter-and-delete
}

function h-trimmed() {
	fc -l -n 0 | perl -lpXE 's/(\s | (\\n))+$ | ^(\s | (\\n))+//gnx'
}

function h-stats() {
	fc -l 1 | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n20
}
