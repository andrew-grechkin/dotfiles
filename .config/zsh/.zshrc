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
    :
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

if [[ -n "$ZSH_HIGHLIGHT_STYLES" ]]; then
    ZSH_HIGHLIGHT_STYLES[alias]='fg=11,bold'
    ZSH_HIGHLIGHT_STYLES[command]='fg=10,bold'
fi

WORDCHARS="${WORDCHARS/\/}:+"

# => Use zsh help search ------------------------------------------------------------------------------------------ {{{1

(( $+aliases[run-help] )) && unalias run-help
autoload -Uz run-help

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
fpath=("$ZDOTDIR/completion" "$XDG_DATA_HOME/completion" "${fpath[@]}")

() {
    local file
    local -a plugins
    plugins+=("$ZDOTDIR/lib"/*.zsh(N))
    plugins+=("$ZDOTDIR/lib"/**/*.plugin.zsh(N))
    plugins+=("$ZDOTDIR/lib"/**/*.theme.zsh(N))
    plugins+=("$XDG_DATA_HOME/3rdparty"/**/*.plugin.zsh(N))

    for file in "${plugins[@]}"; do
        builtin source "$file"
    done
}

# => PATH prepare (head) ------------------------------------------------------------------------------------------ {{{1

[[ -n "$HOMEBREW_PREFIX" ]] && [[ -d "$HOMEBREW_PREFIX" ]] && path=("$HOMEBREW_PREFIX/bin"       "${path[@]}")
[[ -n "$HOMEBREW_PREFIX" ]] && [[ -d "$HOMEBREW_PREFIX" ]] && path=("$HOMEBREW_PREFIX/sbin"      "${path[@]}")
[[ -n "$PERLBREW_PATH"                                  ]] && path=("${(ps/:/)PERLBREW_PATH[@]}" "${path[@]}")
[[ -d "$HOME/.local/bin"                                ]] && path=("$HOME/.local/bin"           "${path[@]}")
[[ -d "$HOME/.local/script"                             ]] && path=("$HOME/.local/script"        "${path[@]}")

path=("$HOME/.local/scripts-ext"/*(-FN) "${path[@]}")

if [[ -n "$HOSTNAME" && "$HOSTNAME" =~ king\.com$ ]]; then
    [[ -d "$HOME/.cache/fzf/bin"                        ]] && path=("$HOME/.cache/fzf/bin"  "${path[@]}")
    [[ -d "$HOME/.local/nvim/bin"                       ]] && path=("$HOME/.local/nvim/bin" "${path[@]}")
fi

export PATH

# => generate CDPATH ---------------------------------------------------------------------------------------------- {{{1

() {
    local dir

    cdpath=()
    for dir in "$HOME/git/private" "$HOME/git" "$HOME"/git/*(-FN) "/usr/local/git_tree"; do
        [[ -d "$dir" ]] && cdpath+=("$dir")
    done

    export CDPATH
}

# => -------------------------------------------------------------------------------------------------------------- {{{1

source-file "$XDG_CONFIG_HOME/shell/interactive.work"

if [[ -n "$VISUAL" && ! -x $(command -v "$VISUAL") ]]; then
    unset VISUAL
fi

if [[ -n "$EDITOR" && ! -x $(command -v "$EDITOR") ]]; then
    unset EDITOR
fi

# => show profiler ------------------------------------------------------------------------------------------------ {{{1

# zprof
