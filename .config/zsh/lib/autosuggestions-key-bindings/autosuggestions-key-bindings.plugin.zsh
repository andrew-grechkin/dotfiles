# vim: filetype=zsh foldmethod=marker

# => F1, F2 ------------------------------------------------------------------------------------------------------- {{{1

bindkey  "${terminfo[kf1]}"      autosuggest-execute
bindkey  "${terminfo[kf2]}"      autosuggest-execute

# => Alt-a -------------------------------------------------------------------------------------------------------- {{{1

bindkey  '\ea'                   autosuggest-accept
