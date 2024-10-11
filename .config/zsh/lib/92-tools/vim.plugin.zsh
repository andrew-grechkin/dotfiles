# vim: filetype=sh foldmethod=marker

# => aliases ------------------------------------------------------------------------------------------------------ {{{1

alias vman='MANPAGER="nvim +Man! -c \":nnoremap <buffer> q :quitall<CR>\"" man'

# => functions ---------------------------------------------------------------------------------------------------- {{{1

functions menu-nvim() {
	ITEMS=("default" "kickstart" "LazyVim" "NvChad" "AstroNvim")
	CONFIG=$(printf "%s\n" "${ITEMS[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)

	if [[ -z $CONFIG ]]; then
		echo "Nothing selected"
		return 0
	elif [[ $CONFIG != "default" ]]; then
		export NVIM_APPNAME=$CONFIG
		unset VIMINIT
	fi

	nvim "$@"
}
