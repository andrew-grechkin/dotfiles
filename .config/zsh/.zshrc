# vim: filetype=zsh foldmethod=marker

source-file "$XDG_CONFIG_HOME/shell/rc"
source-file "$XDG_CONFIG_HOME/shell/rc.work"

export HISTORY_IGNORE='(exit( *)#|history( *)#|[bfr]g *|cd *|l[alsh] *|less *|vi[m]# *|kill *)'

# => PATH prepare (tail) ----------------------------------------------------------------------------------------- {{{1

typeset -U PATH path
[[ -d "$HOME/.local/bin"                                ]] && path+=("$HOME/.local/bin")
[[ -d "$HOME/.local/script"                             ]] && path+=("$HOME/.local/script")
[[ -d "$HOME/.local/script-private"                     ]] && path+=("$HOME/.local/script-private")
[[ -d "$HOME/.local/script-work"                        ]] && path+=("$HOME/.local/script-work")
[[ -d "$HOME/.local/usr/bin"                            ]] && path+=("$HOME/.local/usr/bin")
[[ -d "$HOME/.cache/bin"                                ]] && path+=("$HOME/.cache/bin")
[[ -d "$HOME/.cache/fzf/bin"                            ]] && path+=("$HOME/.cache/fzf/bin")
[[ -d "$HOME/.local/share/nvim/mason/bin"               ]] && path+=("$HOME/.local/share/nvim/mason/bin")
[[ -d "/volume1/local/arch/bin"                         ]] && path+=("/volume1/local/arch/bin")
[[ -d "/volume1/local/arch/usr/bin"                     ]] && path+=("/volume1/local/arch/usr/bin")
[[ -d "/volume1/local/arch/usr/bin/core_perl"           ]] && path+=("/volume1/local/arch/usr/bin/core_perl")
[[ -d "/volume1/local/arch/usr/bin/site_perl"           ]] && path+=("/volume1/local/arch/usr/bin/core_perl")
[[ -d "/volume1/local/arch/usr/bin/vendor_perl"         ]] && path+=("/volume1/local/arch/usr/bin/vendor_perl")
[[ -n "$GOPATH"                ]] && [[ -d "$GOPATH"                ]] && path+=("$GOPATH/bin")
# [[ -n "$GEM_HOME"              ]] && [[ -d "$GEM_HOME"              ]] && path+=("$GEM_HOME/bin")
[[ -n "$XDG_DATA_HOME/npm/bin" ]] && [[ -d "$XDG_DATA_HOME/npm/bin" ]] && path+=("$XDG_DATA_HOME/npm/bin")

export PATH

# => load library and plugins ------------------------------------------------------------------------------------ {{{1

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

# => PATH prepare (head) ----------------------------------------------------------------------------------------- {{{1

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

# => Use zsh help search ----------------------------------------------------------------------------------------- {{{1

(( $+aliases[run-help] )) && unalias run-help
autoload -Uz run-help

# => show profiler ----------------------------------------------------------------------------------------------- {{{1

# zprof
