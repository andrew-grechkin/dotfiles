# grand ZSH theme
# vim: syntax=zsh foldmethod=marker
# url: http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Version-Control-Information
# url: https://github.com/zsh-users/zsh/blob/master/Misc/vcs_info-examples
# url: https://timothybasanov.com/2016/04/23/zsh-prompt-and-vcs_info.html

autoload -Uz vcs_info

setopt PROMPT_SUBST

function precmd() {
	vcs_info
}

() {
	typeset -AHg ZSH_THEME
	ZSH_THEME['GIT_PROMPT_PREFIX']='%K{23}%F{231}'
	ZSH_THEME['GIT_PROMPT_SUFFIX']='%K{36}%F{23}'
	ZSH_THEME['GIT_PROMPT_DIRTY']=''
	ZSH_THEME['GIT_PROMPT_CLEAN']=''
	ZSH_THEME['GIT_PROMPT_AHEAD']='%F{cyan}↑'
	ZSH_THEME['GIT_PROMPT_BEHIND']='%F{cyan}↓'
	ZSH_THEME['GIT_PROMPT_ADDED']='%F{green}+'
	ZSH_THEME['GIT_PROMPT_MODIFIED']='%F{yellow}*'
	ZSH_THEME['GIT_PROMPT_DELETED']='%F{red}-'
	ZSH_THEME['GIT_PROMPT_RENAMED']='%F{yellow}➜'
	ZSH_THEME['GIT_PROMPT_UNMERGED']='%F{magenta}?'
	ZSH_THEME['GIT_PROMPT_UNTRACKED']='%F{red}+'
	ZSH_THEME['GIT_PROMPT_SHA_BEFORE']='%F{231}'
	ZSH_THEME['GIT_PROMPT_SHA_AFTER']='%K{black}%F{36}'
	ZSH_THEME['CLOCK']='%K{29}%F{231}%T%f%k'
	ZSH_THEME['CWD']='%F{cyan}:%f%F{blue}%~%f'

	MODE_INDICATOR='%F{yellow}➤%F{yellow}➤➤%f'

	local history='$[HISTCMD-1]'
	local no_error='%K{black}%F{29}%f%k'
	local is_error="%K{red}%F{29}%F{231}${history}↵%?%K{black}%F{red}%f%k"
	ZSH_THEME['RETURN']="%(?.${no_error}.${is_error})"

	# Check if we are root
	[[ $UID -ne 0 ]] && ZSH_THEME['USER']='%F{green}%n%f' || ZSH_THEME['USER']='%F{red}%n%f'

	# Check if we are on SSH or not
	[[ -n "$SSH_CLIENT" || -n "$SSH2_CLIENT" ]] && ZSH_THEME['HOST']='%F{red}%M%f' || ZSH_THEME['HOST']='%F{green}%M%f'

	PROMPT="╭${ZSH_THEME['CLOCK']}${ZSH_THEME['RETURN']}${ZSH_THEME['USER']}%F{cyan}@%f${ZSH_THEME['HOST']}${ZSH_THEME['CWD']} "'${vcs_info_msg_0_}'"%k%f%{$reset_color%}
╰%!─➤${RPS1}%k%f% "
	RPROMPT=''
}

zstyle    ':vcs_info:*'                 debug                    false
zstyle    ':vcs_info:*'                 enable                   git
zstyle    ':vcs_info:*'                 check-for-changes        true
zstyle    ':vcs_info:*'                 check-for-staged-changes true
zstyle    ':vcs_info:*'                 get-revision             true
zstyle    ':vcs_info:*'                 stagedstr                '%F{green}+'
zstyle    ':vcs_info:*'                 unstagedstr              '%F{yellow}*'
zstyle -e ':vcs_info:git+set-message:*' hooks                    'reply=(${${(k)functions[(I)[+]vi-git-set-message*]}#+vi-})'
zstyle    ':vcs_info:*'                 formats                  '%K{23}%F{231}%K{29}%F{23}%F{233}%i%k%F{29}%u%c%m '
zstyle    ':vcs_info:*'                 actionformats            '%K{23}%F{231}%K{29}%F{23}%F{233}%i%k%F{29}%a %m '
