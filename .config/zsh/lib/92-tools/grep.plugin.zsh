# vim: filetype=zsh foldmethod=marker

function igrep() {
	fzf_args=(
		--bind="change:reload(rg --color=always --line-number {q})"
		--bind="ctrl-m:become(echo {1} | perl -F: -aE 'say \$F[1]; say \$F[0]' | xargs -r bash -c '</dev/tty $VISUAL +\$0 \$1')"
		--bind="start:change-query()"
		--phony
		--query="."
		--reverse
	)
	echo 'loading...' | fzf "${fzf_args[@]}"
}

alias grep=" grep    --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"
alias gd="   grep -r --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"

alias -g G='| grep'
alias -g Gi='| grep -i'
