# vim: filetype=zsh foldmethod=marker

function tsv-header () {
	head -n 1 "$@" | tr $'\t' $'\n' | nl -ba
}

function tsv-but-header () {
	tail -n +2 "$@"
}
