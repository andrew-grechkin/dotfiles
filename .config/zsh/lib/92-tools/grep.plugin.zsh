# vim: filetype=zsh foldmethod=marker

function igrep() {
	sk --ansi -i -c "rg --color=always --line-number '{}'"
}

alias grep=" grep    --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"
alias gd="   grep -r --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"

alias -g G='| grep'
alias -g Gi='| grep -i'
