# vim: filetype=zsh foldmethod=marker

if [[ -x "$(command -v luarocks)" ]]; then
	eval "$(luarocks path --bin)"
fi
