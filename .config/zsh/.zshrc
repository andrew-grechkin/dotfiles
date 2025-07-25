# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

# => environment -------------------------------------------------------------------------------------------------- {{{1

export LESSHISTFILE=-

if [[ -r "$XDG_CONFIG_HOME/nvim/init.lua" ]]; then
	export VIMINIT='let $MYVIMRC = has("nvim-0.10") ? "$XDG_CONFIG_HOME/nvim/init.lua" : "$XDG_CONFIG_HOME/vim/init.vim" | so $MYVIMRC'
else
	export VIMINIT='let $MYVIMRC = "$XDG_CONFIG_HOME/vim/init.vim" | so $MYVIMRC'
fi

if [[ "$IS_NAS" == "1" ]]; then
	export PAGER="less"
elif [[ -n "$HOSTNAME" && "$HOSTNAME" =~ king\.com$ ]]; then
	# on kvm use defaults
	true
else
	export HAS_MOUSE='1'
	export LESS='-x4 -iRw --mouse'
fi

# => -------------------------------------------------------------------------------------------------------------- {{{1

# man: zshmodules
if [[ "$IS_NAS" != "0" ]]; then
	if [[ "$IS_NAS" != "1" ]]; then
		[[ $COLORTERM = *(24bit|truecolor)* ]] || zmodload zsh/nearcolor
	fi
fi

# => -------------------------------------------------------------------------------------------------------------- {{{1

source-file "$XDG_CONFIG_HOME/shell/rc.work"

# => hide all ZSH configuration related environment variables ----------------------------------------------------- {{{1

typeset -Hg HYPHEN_INSENSITIVE REPORTTIME
HYPHEN_INSENSITIVE=1
REPORTTIME=10

typeset -AHg DIRSTACK
DIRSTACK['file']="$XDG_STATE_HOME/zsh/dirs@$HOSTNAME"
DIRSTACK['size']=20

# => load library and plugins ------------------------------------------------------------------------------------- {{{1

# https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Completion-System
# https://thevaluable.dev/zsh-completion-guide-examples/
fpath=("$ZDOTDIR/completion" "${fpath[@]}")

FILES+=("$ZDOTDIR/lib"/*.zsh(N))
FILES+=("$ZDOTDIR/lib"/**/*.plugin.zsh(N))
FILES+=("$ZDOTDIR/lib"/**/*.theme.zsh(N))

[[ -d "$XDG_DATA_HOME/3rdparty" ]] && [[ -n "$(find -H $XDG_DATA_HOME/3rdparty -maxdepth 3 -name '*.plugin.zsh' -print -quit)" ]] && {
	FILES+=("$XDG_DATA_HOME/3rdparty"/**/*.plugin.zsh)
}

for FILE in "${FILES[@]}"; do
	builtin source "$FILE"
done

if [[ -n "$ZSH_HIGHLIGHT_STYLES" ]]; then
	ZSH_HIGHLIGHT_STYLES[alias]='fg=11,bold'
	ZSH_HIGHLIGHT_STYLES[command]='fg=10,bold'
fi

# => PATH prepare (head) ------------------------------------------------------------------------------------------ {{{1

[[ -n "$HOMEBREW_PREFIX" ]] && [[ -d "$HOMEBREW_PREFIX" ]] && path=("$HOMEBREW_PREFIX/bin"             "${path[@]}")
[[ -n "$HOMEBREW_PREFIX" ]] && [[ -d "$HOMEBREW_PREFIX" ]] && path=("$HOMEBREW_PREFIX/sbin"            "${path[@]}")
[[ -n "$PERLBREW_PATH"                                  ]] && path=("${(ps/:/)PERLBREW_PATH[@]}"       "${path[@]}")
[[ -d "$HOME/.local/bin"                                ]] && path=("$HOME/.local/bin"                 "${path[@]}")
[[ -d "$HOME/.local/script"                             ]] && path=("$HOME/.local/script"             "${path[@]}")

path=("$HOME/.local/scripts-ext"/*(-FN) "${path[@]}")

if [[ -n "$HOSTNAME" && "$HOSTNAME" =~ king\.com$ ]]; then
	[[ -d "$HOME/.local/nvim/bin"                       ]] && path=("$HOME/.local/nvim/bin" "${path[@]}")
fi

export PATH

WORDCHARS="${WORDCHARS/\/}:+"

# => Use zsh help search ------------------------------------------------------------------------------------------ {{{1

(( $+aliases[run-help] )) && unalias run-help
autoload -Uz run-help

# => generate CDPATH ---------------------------------------------------------------------------------------------- {{{1

function gen-cdpath() {
	setopt NULL_GLOB
	declare -a DIRS
	for FILE in "$HOME"/git/private "$HOME"/git "$HOME"/git/* "/usr/local/git_tree"; do
		[[ -d "${FILE%/}" ]] && DIRS+=("${FILE%/}")
	done

	local IFS=:
	export CDPATH="${DIRS[*]}"
	unset -f gen-cdpath
} &>/dev/null

gen-cdpath

# => -------------------------------------------------------------------------------------------------------------- {{{1

source-file "$XDG_CONFIG_HOME/shell/interactive.work"

if [[ -n "$VISUAL" && ! -x $(command -v "$VISUAL") ]]; then
	unset VISUAL
fi

# => show profiler ------------------------------------------------------------------------------------------------ {{{1

# zprof
