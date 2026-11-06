# vim: filetype=zsh foldmethod=marker
# Based on https://github.com/robbyrussell/oh-my-zsh

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias d='dirs -v'

# => Changing/making/removing directory configuration ------------------------------------------------------------- {{{1

setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# => take --------------------------------------------------------------------------------------------------------- {{{1

function take() {
	mkdir -p "$@" && cd ./"${@:$#}"
}

# => generate CDPATH ---------------------------------------------------------------------------------------------- {{{1

() {
    local dir

    cdpath=()
    for dir in "$HOME/git/private" "$HOME/git" "$HOME"/git/*(-FN) "/usr/local/git_tree"; do
        [[ -d "$dir" ]] && cdpath+=("$dir")
    done

    # NOTE: do not export. Every subshell (scripts, git hooks, Makefile recipes) would resolve relative `cd` through it,
    # so `cd config` could silently land in an unrelated git repo
    # export CDPATH
}

# => Save dirstack history to $DIRSTACK['file'] ------------------------------------------------------------------- {{{1

typeset -AHg DIRSTACK
DIRSTACK[file]="$XDG_STATE_HOME/zsh/dirs@$HOSTNAME"
DIRSTACK[size]=20

if [[ -n "${DIRSTACK[file]}" ]]; then
	DIRSTACK[size]="${DIRSTACK[size]:-20}"

	if  [[ -f "${DIRSTACK[file]}" && ${#dirstack[@]} -eq 0 ]]; then
		dirstack=( ${(f)"$(< "${DIRSTACK[file]}")"} )
		# "cd -" won't work after login by just setting $OLDPWD, so
		[[ -d $dirstack[1] ]] && export OLDPWD="$dirstack[1]"
	fi

	chpwd_functions+=(chpwd_dirpersist)
	function chpwd_dirpersist() {
		if (( ${DIRSTACK[size]} <= 0 )) || [[ -z "${DIRSTACK[file]}" ]]; then
			return
		fi
		local exclude=(${HOME})
		local -ax my_stack
		my_stack=(${PWD} ${dirstack[@]})
		my_stack=(${my_stack[@]:|exclude})
		builtin print -l ${(u)my_stack[@]: 0:${DIRSTACK[size]}} >! "${DIRSTACK[file]}"
	}
fi
