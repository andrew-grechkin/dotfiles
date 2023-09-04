# vim: filetype=zsh foldmethod=marker
# Based on https://github.com/robbyrussell/oh-my-zsh

alias h='history'
alias h-disable='HF="$HISTFILE"; fc -p; fc -R "$HF"'
# alias crap='history -d $((HISTCMD-1))'

# do not save failed command in history
function zshaddhistory() {
	whence ${${(z)1}[1]} >| /dev/null || return 2
}

# => History command configuration https://zsh.sourceforge.io/Doc/Release/Options.html#History ------------------- {{{1

setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_ALL_DUPS                                                    # ignore duplicated commands history list
setopt HIST_IGNORE_SPACE                                                       # ignore commands that start with space
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_BY_COPY
setopt HIST_VERIFY                                                             # show command with history expansion to user before running it
setopt SHARE_HISTORY                                                           # share command history data

# => History file configuration ---------------------------------------------------------------------------------- {{{1

HISTSIZE=65535
SAVEHIST=65535

# => History wrapper --------------------------------------------------------------------------------------------- {{{1

function omz_history {
	local clear list
	zparseopts -E c=clear l=list

	if [[ -n "$clear" ]]; then
		# if -c provided, clobber the history file
		echo -n >| "$HISTFILE"
		echo >&2 History file deleted. Reload the session to see its effects.
	elif [[ -n "$list" ]]; then
		# if -l provided, run as if calling `fc' directly
		builtin fc "$@"
	else
		# unless a number is provided, show all history events (starting from 1)
		[[ ${@[-1]} = *[0-9]* ]] && builtin fc -l "$@" || builtin fc -l "$@" 1
	fi
}

# => Timestamp format -------------------------------------------------------------------------------------------- {{{1

# case $HIST_STAMPS in
# 	"mm/dd/yyyy") alias history='omz_history -f' ;;
# 	"dd.mm.yyyy") alias history='omz_history -E' ;;
# 	"yyyy-mm-dd") alias history='omz_history -i' ;;
# 	""          ) alias history='omz_history' ;;
# 	*           ) alias history="omz_history -t '$HIST_STAMPS'" ;;
# esac
