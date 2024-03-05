# vim: filetype=zsh foldmethod=marker

function igrep() {
	sk --ansi -i -c "rg --color=always --line-number '{}'"
}

function is-grep-flag-available() {
	echo | grep $1 "" >/dev/null 2>&1
}

local GREP_OPTIONS=""
local VCS_FOLDERS="{.bzr,CVS,.git,.hg,.svn}"

if is-grep-flag-available --color=auto; then
	GREP_OPTIONS+=" --color=auto"
fi

if is-grep-flag-available --exclude-dir=.cvs; then
	GREP_OPTIONS+=" --exclude-dir=$VCS_FOLDERS"
elif is-grep-flag-available --exclude=.cvs; then
	GREP_OPTIONS+=" --exclude=$VCS_FOLDERS"
fi

unfunction is-grep-flag-available

alias grep="grep $GREP_OPTIONS"
alias gd="grep $GREP_OPTIONS -ri"

alias -g G='| grep'
alias -g Gi='| grep -i'
