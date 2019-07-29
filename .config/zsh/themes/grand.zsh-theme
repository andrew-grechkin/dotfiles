# grand ZSH Theme - Preview:
# Based on gnzh theme

setopt PROMPT_SUBST

() {
	# Format for git_prompt_info()
	ZSH_THEME_GIT_PROMPT_PREFIX="%K{23}%F{231}%B"
	ZSH_THEME_GIT_PROMPT_SUFFIX="%b%K{36}%F{23}"

	# Format for parse_git_dirty()
	ZSH_THEME_GIT_PROMPT_DIRTY=""
	ZSH_THEME_GIT_PROMPT_CLEAN=""

	# Format for git_prompt_ahead()
	ZSH_THEME_GIT_PROMPT_AHEAD="%B%F{cyan}↑"
	ZSH_THEME_GIT_PROMPT_BEHIND="%B%F{cyan}↓"

	# Format for git_prompt_status()
	ZSH_THEME_GIT_PROMPT_ADDED="%B%F{green}+"
	ZSH_THEME_GIT_PROMPT_MODIFIED="%B%F{yellow}*"
	ZSH_THEME_GIT_PROMPT_DELETED="%B%F{red}-"
	ZSH_THEME_GIT_PROMPT_RENAMED="%B%F{yellow}➜"
	ZSH_THEME_GIT_PROMPT_UNMERGED="%B%F{magenta}?"
	ZSH_THEME_GIT_PROMPT_UNTRACKED="%B%F{red}+"

	# Format for git_prompt_long_sha() and git_prompt_short_sha()
	ZSH_THEME_GIT_PROMPT_SHA_BEFORE="%F{231}%B"
	ZSH_THEME_GIT_PROMPT_SHA_AFTER="%b%K{black}%F{36}"

	local git_branch=' $(git_prompt_info)$(git_prompt_short_sha)$(git_prompt_status)%b%f%k'

	MODE_INDICATOR="%F{yellow}%B➤%b%F{yellow}➤➤%f"

	local PR_USER PR_USER_OP PR_PROMPT PR_HOST

	local clock='%K{29}%F{231}%B%T%b%f%k'

	local history='$[HISTCMD-1]'
	local no_error="%K{black}%F{29}%f%k"
	local is_error="%K{red}%F{29}%F{231}%B${history}↵%?%b%K{black}%F{red}%f%k"
	local return_code="%(?.${no_error}.${is_error})"

	# Check the UID
	if [[ $UID -ne 0 ]]; then # normal user
		PR_USER='%F{green}%n%f'
		PR_USER_OP='%F{green}%#%f'
		PR_PROMPT='%f➤%f'
	else # root
		PR_USER='%F{red}%n%f'
		PR_USER_OP='%F{red}%#%f'
		PR_PROMPT='%F{red}➤%f'
	fi

	# Check if we are on SSH or not
	if [[ -n "$SSH_CLIENT" || -n "$SSH2_CLIENT" ]]; then
		PR_HOST='%F{red}%M%f' # SSH
	else
		PR_HOST='%F{green}%M%f' # no SSH
	fi

	local user_host=" ${PR_USER}%F{cyan}@%f${PR_HOST}"
	local current_dir="%F{cyan}:%f%B%F{blue}%~%f%b"

PROMPT="╭${clock}${return_code}${user_host}${current_dir}${git_branch}
╰%!─${PR_PROMPT}${RPS1} "
RPROMPT=""
}
