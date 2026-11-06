# vim: filetype=zsh foldmethod=marker

# => short commands ----------------------------------------------------------------------------------------------- {{{1

function g() {
	if [[ $# -gt 0 ]]; then
		git "$@"
	else
		git -c safe.directory='*' status
	fi
}

# => config manipulation ------------------------------------------------------------------------------------------ {{{1
# man: git-config

function git-set-fast() {
	git config zsh-prompt.status fast
}

# => prompt vcs_info ---------------------------------------------------------------------------------------------- {{{1

function +vi-git-set-message-status() {
	local config="$(command git config --get zsh-prompt.status)"
	[[ "$config" == "hide" ]] && return
	[[ "$config" == "fast" ]] && local param='-uno'

	local index=$(command git status --porcelain $param -b 2> /dev/null)
	local -a parts
	$(echo "$index" | grep -E '^(\?\?)\ '             &> /dev/null) && parts+=("${ZSH_THEME['GIT_PROMPT_UNTRACKED']}")
#	$(echo "$index" | grep -E '^(A |M |MM)\ '         &> /dev/null) && parts+=("${ZSH_THEME['GIT_PROMPT_ADDED']}")
#	$(echo "$index" | grep -E '^(\ M|AM|MM|\ T)\ '    &> /dev/null) && parts+=("${ZSH_THEME['GIT_PROMPT_MODIFIED']}")
	$(echo "$index" | grep -E '^(\ D|D |AD)\ '        &> /dev/null) && parts+=("${ZSH_THEME['GIT_PROMPT_DELETED']}")
	$(echo "$index" | grep    '^R  '                  &> /dev/null) && parts+=("${ZSH_THEME['GIT_PROMPT_RENAMED']}")
	$(echo "$index" | grep    '^UU '                  &> /dev/null) && parts+=("${ZSH_THEME['GIT_PROMPT_UNMERGED']}")
#	$(echo "$index" | grep    '^## [^ ]\+ .*ahead'    &> /dev/null) && parts+=("${ZSH_THEME['GIT_PROMPT_AHEAD']}")
#	$(echo "$index" | grep    '^## [^ ]\+ .*behind'   &> /dev/null) && parts+=("${ZSH_THEME['GIT_PROMPT_BEHIND']}")
#	$(echo "$index" | grep    '^## [^ ]\+ .*diverged' &> /dev/null) && parts+=("${ZSH_THEME['GIT_PROMPT_DIVERGED']}")
	$(command git rev-parse --verify refs/stash >/dev/null 2>&1)    && parts+=("${ZSH_THEME['GIT_PROMPT_STASHED']}")

	# join array without delimeter
#	hook_com[misc]+="${parts[*]}"
	hook_com[misc]+="${(j::)parts}"
}

function +vi-git-set-message-upstream_diverge() {
	local branch="${hook_com[branch]}"
	local -a parts
	local ahead="$(command git rev-list ${branch}@{upstream}..HEAD 2>/dev/null | wc -l)"
	(( $ahead )) && parts+=("${ZSH_THEME['GIT_PROMPT_AHEAD']}${ahead}")
	local behind="$(command git rev-list HEAD..${branch}@{upstream} 2>/dev/null | wc -l)"
	(( $behind )) && parts+=("${ZSH_THEME['GIT_PROMPT_BEHIND']}${behind}")

	# join array with delimeter
	hook_com[misc]+="${(j:/:)parts}"
}
