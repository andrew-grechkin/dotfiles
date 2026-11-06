setopt CSH_NULL_GLOB
setopt EXTENDED_GLOB
setopt GLOB_DOTS
setopt IGNORE_EOF
setopt INTERACTIVECOMMENTS                                                     # recognize comments
setopt LONG_LIST_JOBS
setopt MULTIOS
setopt NUMERIC_GLOB_SORT
setopt RE_MATCH_PCRE

autoload -Uz zmv zcp zln
autoload -Uz add-zsh-hook

# Required for $langinfo
# zmodload zsh/langinfo

# => Use zsh help search ------------------------------------------------------------------------------------------ {{{1

(( $+aliases[run-help] )) && unalias run-help
autoload -Uz run-help
