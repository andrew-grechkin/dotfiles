# vim: filetype=zsh foldmethod=marker

# => exports ------------------------------------------------------------------------------------------------------ {{{1

if [[ -d "$XDG_DATA_HOME/nvm" ]]; then
	export NVM_DIR="$XDG_DATA_HOME/nvm"
fi

# => main --------------------------------------------------------------------------------------------------------- {{{1

if [[ -r "$NVM_DIR/nvm.sh" ]]; then
	source "$NVM_DIR/nvm.sh"
fi
