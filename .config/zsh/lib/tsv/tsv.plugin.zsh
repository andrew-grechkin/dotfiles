# vim: filetype=zsh foldmethod=marker

# => aliases ------------------------------------------------------------------------------------------------------ {{{1

function tsv-header () {
	head -n 1 "$@" | tr $'\t' $'\n' | nl -ba
}

function tsv-but-header () {
	tail -n +2 "$@"
}

# => completion --------------------------------------------------------------------------------------------------- {{{1

if [[ -r ~/.config/tsv-utils/bash_completion/tsv-utils ]]; then
	source ~/.config/tsv-utils/bash_completion/tsv-utils
fi
