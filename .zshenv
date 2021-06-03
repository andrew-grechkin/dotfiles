# vim: syntax=zsh foldmethod=marker

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

[[ -z "$ZSH_INITED" ]] && {
	export ZSH_INITED=1

	[[ -n "$ZDOTDIR" ]]   && export ZDOTDIR=$XDG_CONFIG_HOME/zsh

	[[ -r "$XDG_CONFIG_HOME/zsh/.zshenv" ]] && source "$XDG_CONFIG_HOME/zsh/.zshenv"
}
