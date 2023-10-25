# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

# => environment -------------------------------------------------------------------------------------------------- {{{1

export HOSTNAME="${HOSTNAME:-$(hostname)}"
export LANG=${LANG:-en_US.utf8}
export VIMINIT='let $MYVIMRC = has("nvim-0.5") ? "$HOME/.config/nvim/init.lua" : "$HOME/.config/vim/vimrc" | so $MYVIMRC'

# => -------------------------------------------------------------------------------------------------------------- {{{1

source-file "$XDG_CONFIG_HOME/shell/rc.work"

# => hide all ZSH configuration related environment variables ----------------------------------------------------- {{{1

typeset -Hg HISTORY_BASE HYPHEN_INSENSITIVE REPORTTIME
HISTORY_BASE=$XDG_CACHE_HOME/per-directory-history
HYPHEN_INSENSITIVE=1
REPORTTIME=10

typeset -AHg DIRSTACK
DIRSTACK['file']="$XDG_CACHE_HOME/z_dirs"
DIRSTACK['size']=20

# => load library and plugins ------------------------------------------------------------------------------------- {{{1

# https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Completion-System
# https://thevaluable.dev/zsh-completion-guide-examples/
fpath=("$ZDOTDIR/completion" "${fpath[@]}")

files=()
files+=("$ZDOTDIR/lib"/*.zsh)
files+=("$ZDOTDIR/lib"/**/*.plugin.zsh)
files+=("$ZDOTDIR/lib"/**/*.theme.zsh)

[[ -d "$ZDOTDIR/3rdparty" ]] && [[ -n "$(find $ZDOTDIR/3rdparty -maxdepth 2 -name '*.plugin.zsh' -print -quit)" ]] && {
	files+=("$ZDOTDIR/3rdparty"/**/*.plugin.zsh)
}

for FILE in "${files[@]}"; do
	builtin source "$FILE"
done

# => PATH prepare (head) ------------------------------------------------------------------------------------------ {{{1

[[ -n "$HOMEBREW_PREFIX" ]] && [[ -d "$HOMEBREW_PREFIX" ]] && path=("$HOMEBREW_PREFIX/bin"        "${path[@]}")
[[ -n "$HOMEBREW_PREFIX" ]] && [[ -d "$HOMEBREW_PREFIX" ]] && path=("$HOMEBREW_PREFIX/sbin"       "${path[@]}")
[[ -n "$PERLBREW_PATH"                                  ]] && path=("${(ps/:/)PERLBREW_PATH[@]}"  "${path[@]}")
[[ -d "$HOME/.local/bin"                                ]] && path=("$HOME/.local/bin"            "${path[@]}")
[[ -d "$HOME/.local/script"                             ]] && path=("$HOME/.local/script"         "${path[@]}")
[[ -d "$HOME/.local/script-private"                     ]] && path=("$HOME/.local/script-private" "${path[@]}")
[[ -d "$HOME/.local/script-work"                        ]] && path=("$HOME/.local/script-work"    "${path[@]}")
[[ -d "$HOME/.cache/bin"                                ]] && path=("$HOME/.cache/bin"            "${path[@]}")

export PATH

WORDCHARS=${WORDCHARS/\/}

# => Use zsh help search ------------------------------------------------------------------------------------------ {{{1

(( $+aliases[run-help] )) && unalias run-help
autoload -Uz run-help

# => show profiler ------------------------------------------------------------------------------------------------ {{{1

# zprof
