# vim: filetype=zsh foldmethod=marker

# => short commands ----------------------------------------------------------------------------------------------- {{{1

function g() {
	if [[ $# -gt 0 ]]; then
		git "$@"
	else
		git status
	fi
}

# => config manipulation ------------------------------------------------------------------------------------------ {{{1
# man: git-config

function git-set-fast() {
	git config zsh-prompt.status fast
}

# => prompt vcs_info ---------------------------------------------------------------------------------------------- {{{1

function +vi-git-set-message-status() {
	local BRANCH="${hook_com[branch]}"

	local CONFIG="$(command git config --get zsh-prompt.status)"
	[[ "$CONFIG" == "hide" ]] && return
	[[ "$CONFIG" == "fast" ]] && local PARAM='-uno'

	local INDEX=$(command git status --porcelain $PARAM -b 2> /dev/null)
	local -a STATUS
	$(echo "$INDEX" | grep -E '^(\?\?)\ '             &> /dev/null) && STATUS+=("${ZSH_THEME['GIT_PROMPT_UNTRACKED']}")
#	$(echo "$INDEX" | grep -E '^(A |M |MM)\ '         &> /dev/null) && STATUS+=("${ZSH_THEME['GIT_PROMPT_ADDED']}")
#	$(echo "$INDEX" | grep -E '^(\ M|AM|MM|\ T)\ '    &> /dev/null) && STATUS+=("${ZSH_THEME['GIT_PROMPT_MODIFIED']}")
	$(echo "$INDEX" | grep -E '^(\ D|D |AD)\ '        &> /dev/null) && STATUS+=("${ZSH_THEME['GIT_PROMPT_DELETED']}")
	$(echo "$INDEX" | grep    '^R  '                  &> /dev/null) && STATUS+=("${ZSH_THEME['GIT_PROMPT_RENAMED']}")
	$(echo "$INDEX" | grep    '^UU '                  &> /dev/null) && STATUS+=("${ZSH_THEME['GIT_PROMPT_UNMERGED']}")
#	$(echo "$INDEX" | grep    '^## [^ ]\+ .*ahead'    &> /dev/null) && STATUS+=("${ZSH_THEME['GIT_PROMPT_AHEAD']}")
#	$(echo "$INDEX" | grep    '^## [^ ]\+ .*behind'   &> /dev/null) && STATUS+=("${ZSH_THEME['GIT_PROMPT_BEHIND']}")
#	$(echo "$INDEX" | grep    '^## [^ ]\+ .*diverged' &> /dev/null) && STATUS+=("${ZSH_THEME['GIT_PROMPT_DIVERGED']}")
	$(command git rev-parse --verify refs/stash >/dev/null 2>&1)    && STATUS+=("${ZSH_THEME['GIT_PROMPT_STASHED']}")

	# join array without delimeter
#	hook_com[misc]+="${STATUS[*]}"
	hook_com[misc]+="${(j::)STATUS}"
}

function +vi-git-set-message-upstream_diverge() {
	local BRANCH="${hook_com[branch]}"
	local -a STATUS
	local AHEAD="$(command git rev-list ${BRANCH}@{upstream}..HEAD 2>/dev/null | wc -l)"
	(( $AHEAD )) && STATUS+=("${ZSH_THEME['GIT_PROMPT_AHEAD']}${AHEAD}")
	local BEHIND="$(command git rev-list HEAD..${branch}@{upstream} 2>/dev/null | wc -l)"
	(( $BEHIND )) && STATUS+=("${ZSH_THEME['GIT_PROMPT_BEHIND']}${BEHIND}")

	# join array with delimeter
	hook_com[misc]+="${(j:/:)STATUS}"
}

# => prompt ------------------------------------------------------------------------------------------------------- {{{1
# Based on https://github.com/robbyrussell/oh-my-zsh

# Outputs current branch info in prompt format
function git_prompt_info() {
	if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
		local ref
		ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
		ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
		echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
	fi
}

# Checks if working tree is dirty
function parse_git_dirty() {
	local STATUS=''
	if [[ -n $ZSH_THEME_GIT_PROMPT_DIRTY ]] && [[ "$(command git config --get oh-my-zsh.hide-dirty)" != "1" ]]; then
		local -a FLAGS
		FLAGS=('--porcelain')

		if [[ $POST_1_7_2_GIT -gt 0 ]]; then
			FLAGS+='--ignore-submodules=dirty'
		fi
		if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
			FLAGS+='--untracked-files=no'
		fi
		STATUS=$(command git status ${FLAGS} 2> /dev/null | tail -n1)
	fi
	if [[ -n $STATUS ]]; then
		echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
	else
		echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
	fi
}

# Gets the difference between the local and remote branches
function git_remote_status() {
	local remote ahead behind git_remote_status git_remote_status_detailed
	remote=${$(command git rev-parse --verify ${hook_com[branch]}@{upstream} --symbolic-full-name 2>/dev/null)/refs\/remotes\/}
	if [[ -n ${remote} ]]; then
		ahead=$(command git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
		behind=$(command git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)

		if [[ $ahead -eq 0 ]] && [[ $behind -eq 0 ]]; then
			git_remote_status="$ZSH_THEME_GIT_PROMPT_EQUAL_REMOTE"
		elif [[ $ahead -gt 0 ]] && [[ $behind -eq 0 ]]; then
			git_remote_status="$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE"
			git_remote_status_detailed="$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE$((ahead))%{$reset_color%}"
		elif [[ $behind -gt 0 ]] && [[ $ahead -eq 0 ]]; then
			git_remote_status="$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE"
			git_remote_status_detailed="$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE$((behind))%{$reset_color%}"
		elif [[ $ahead -gt 0 ]] && [[ $behind -gt 0 ]]; then
			git_remote_status="$ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE"
			git_remote_status_detailed="$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE$((ahead))%{$reset_color%}$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE$((behind))%{$reset_color%}"
		fi

		if [[ -n $ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_DETAILED ]]; then
			git_remote_status="$ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_PREFIX$remote$git_remote_status_detailed$ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_SUFFIX"
		fi

		echo $git_remote_status
	fi
}

# Outputs the name of the current branch
# Usage example: git pull origin $(git_current_branch)
# Using '--quiet' with 'symbolic-ref' will not cause a fatal error (128) if
# it's not a symbolic ref, but in a Git repo.
function git_current_branch() {
	local ref
	ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
	local ret=$?
	if [[ $ret != 0 ]]; then
		[[ $ret == 128 ]] && return  # no git repo.
		ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
	fi
	echo ${ref#refs/heads/}
}

# Gets the number of commits ahead from remote
function git_commits_ahead() {
	if command git rev-parse --git-dir &>/dev/null; then
		local commits="$(git rev-list --count @{upstream}..HEAD 2>/dev/null)"
		if [[ -n "$commits" && "$commits" != 0 ]]; then
			echo "$ZSH_THEME_GIT_COMMITS_AHEAD_PREFIX$commits$ZSH_THEME_GIT_COMMITS_AHEAD_SUFFIX"
		fi
	fi
}

# Gets the number of commits behind remote
function git_commits_behind() {
	if command git rev-parse --git-dir &>/dev/null; then
		local commits="$(git rev-list --count HEAD..@{upstream} 2>/dev/null)"
		if [[ -n "$commits" && "$commits" != 0 ]]; then
			echo "$ZSH_THEME_GIT_COMMITS_BEHIND_PREFIX$commits$ZSH_THEME_GIT_COMMITS_BEHIND_SUFFIX"
		fi
	fi
}

# Outputs if current branch is ahead of remote
function git_prompt_ahead() {
	if [[ -n "$(command git rev-list origin/$(git_current_branch)..HEAD 2> /dev/null)" ]]; then
		echo "$ZSH_THEME_GIT_PROMPT_AHEAD"
	fi
}

# Outputs if current branch is behind remote
function git_prompt_behind() {
	if [[ -n "$(command git rev-list HEAD..origin/$(git_current_branch) 2> /dev/null)" ]]; then
		echo "$ZSH_THEME_GIT_PROMPT_BEHIND"
	fi
}

# Outputs if current branch exists on remote or not
function git_prompt_remote() {
	if [[ -n "$(command git show-ref origin/$(git_current_branch) 2> /dev/null)" ]]; then
		echo "$ZSH_THEME_GIT_PROMPT_REMOTE_EXISTS"
	else
		echo "$ZSH_THEME_GIT_PROMPT_REMOTE_MISSING"
	fi
}

# Formats prompt string for current git commit short SHA
function git_prompt_short_sha() {
	local SHA
	SHA=$(command git rev-parse --short HEAD 2> /dev/null) && echo "${ZSH_THEME_GIT_PROMPT_SHA_BEFORE}${SHA}${ZSH_THEME_GIT_PROMPT_SHA_AFTER}"
}

# Formats prompt string for current git commit long SHA
function git_prompt_long_sha() {
	local SHA
	SHA=$(command git rev-parse HEAD 2> /dev/null) && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}

function git-prompt-status() {
	local CONFIG="$(command git config --get zsh-prompt.status)"
	[[ "$CONFIG" == "hide" ]] && return ""
	[[ "$CONFIG" == "fast" ]] && local PARAM='-uno'

	local INDEX=$(command git status --porcelain $PARAM -b 2> /dev/null)
	local STATUS=""
	$(echo "$INDEX" | grep -E '^(\?\?)\ '             &> /dev/null) && STATUS="${STATUS}${ZSH_THEME_GIT_PROMPT_UNTRACKED}"
	$(echo "$INDEX" | grep -E '^(A |M |MM)\ '         &> /dev/null) && STATUS="${STATUS}${ZSH_THEME_GIT_PROMPT_ADDED}"
	$(echo "$INDEX" | grep -E '^(\ M|AM|MM|\ T)\ '    &> /dev/null) && STATUS="${STATUS}${ZSH_THEME_GIT_PROMPT_MODIFIED}"
	$(echo "$INDEX" | grep -E '^(\ D|D |AD)\ '        &> /dev/null) && STATUS="${STATUS}${ZSH_THEME_GIT_PROMPT_DELETED}"
	$(echo "$INDEX" | grep    '^R  '                  &> /dev/null) && STATUS="${STATUS}${ZSH_THEME_GIT_PROMPT_RENAMED}"
	$(echo "$INDEX" | grep    '^UU '                  &> /dev/null) && STATUS="${STATUS}${ZSH_THEME_GIT_PROMPT_UNMERGED}"
	$(echo "$INDEX" | grep    '^## [^ ]\+ .*ahead'    &> /dev/null) && STATUS="${STATUS}${ZSH_THEME_GIT_PROMPT_AHEAD}"
	$(echo "$INDEX" | grep    '^## [^ ]\+ .*behind'   &> /dev/null) && STATUS="${STATUS}${ZSH_THEME_GIT_PROMPT_BEHIND}"
	$(echo "$INDEX" | grep    '^## [^ ]\+ .*diverged' &> /dev/null) && STATUS="${STATUS}${ZSH_THEME_GIT_PROMPT_DIVERGED}"
	$(command git rev-parse --verify refs/stash >/dev/null 2>&1)    && STATUS="${STATUS}${ZSH_THEME_GIT_PROMPT_STASHED}"
	echo $STATUS
}

# Compares the provided version of git to the version installed and on path
# Outputs -1, 0, or 1 if the installed version is less than, equal to, or
# greater than the input version, respectively.
function git_compare_version() {
	local INPUT_GIT_VERSION INSTALLED_GIT_VERSION i
	INPUT_GIT_VERSION=(${(s/./)1})
	INSTALLED_GIT_VERSION=($(command git --version 2>/dev/null))
	INSTALLED_GIT_VERSION=(${(s/./)INSTALLED_GIT_VERSION[3]})

	for i in {1..3}; do
		if [[ $INSTALLED_GIT_VERSION[$i] -gt $INPUT_GIT_VERSION[$i] ]]; then
			echo 1
			return 0
		fi
		if [[ $INSTALLED_GIT_VERSION[$i] -lt $INPUT_GIT_VERSION[$i] ]]; then
			echo -1
			return 0
		fi
	done
	echo 0
}

# Outputs the name of the current user
# Usage example: $(git_current_user_name)
function git_current_user_name() {
	command git config user.name 2>/dev/null
}

# Outputs the email of the current user
# Usage example: $(git_current_user_email)
function git_current_user_email() {
	command git config user.email 2>/dev/null
}

# This is unlikely to change so make it all statically assigned
POST_1_7_2_GIT=$(git_compare_version "1.7.2")

# Clean up the namespace slightly by removing the checker function
unfunction git_compare_version
