# vim: filetype=zsh foldmethod=marker

[[ -d "$HOME/.config/environment.d" ]] && source "$HOME/.config/environment.d"/*

[[ -z "$ZSH_INITED" ]] && {
	export ZSH_INITED=1

	[[ -n "$ZDOTDIR" ]]   && export ZDOTDIR=$XDG_CONFIG_HOME/zsh

	[[ -r "$XDG_CONFIG_HOME/zsh/.zshenv" ]] && source "$XDG_CONFIG_HOME/zsh/.zshenv"
}
