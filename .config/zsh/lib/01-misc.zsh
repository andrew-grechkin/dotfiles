# Based on https://github.com/robbyrussell/oh-my-zsh

setopt IGNORE_EOF
setopt LONG_LIST_JOBS
setopt INTERACTIVECOMMENTS                                                     # recognize comments
setopt GLOB_DOTS
setopt RE_MATCH_PCRE

autoload -Uz zmv zcp zln
autoload -Uz add-zsh-hook

# only define LC_CTYPE if undefined
if [[ -z "$LC_CTYPE" && -z "$LC_ALL" ]]; then
	export LC_CTYPE=${LANG%%:*} # pick the first entry from LANG
fi
