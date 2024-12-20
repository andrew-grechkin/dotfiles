setopt GLOB_DOTS
setopt IGNORE_EOF
setopt INTERACTIVECOMMENTS                                                     # recognize comments
setopt LONG_LIST_JOBS
setopt MULTIOS
setopt RE_MATCH_PCRE

autoload -Uz zmv zcp zln
autoload -Uz add-zsh-hook

unset READNULLCMD

# only define LC_CTYPE if undefined
if [[ -z "$LC_CTYPE" && -z "$LC_ALL" ]]; then
	export LC_CTYPE=${LANG%%:*} # pick the first entry from LANG
fi

# Required for $langinfo
# zmodload zsh/langinfo
