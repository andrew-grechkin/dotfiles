# vim: syntax=zsh foldmethod=marker

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

[[ -r "$XDG_CONFIG_HOME/zsh/.zshenv" ]] && source "$XDG_CONFIG_HOME/zsh/.zshenv"
