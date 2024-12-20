# vim: filetype=zsh foldmethod=marker
# Based on https://github.com/robbyrussell/oh-my-zsh

# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Zle-Builtins
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets
# http://zshwiki.org/home/zle/bindkeys#reading_terminfo
#
# use ctrl-v to find current terminal key sequence
# man zshzle to find more settings


alias term-enable-csi="printf '\033[>4;1m'"
alias term-showkey="showkey -a"

# => Prepare terminfo --------------------------------------------------------------------------------------------- {{{1
# Make sure the terminal is in application mode, when zle is active. Only then are the values from $terminfo are valid.

if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
	function zle-line-init () {
		echoti smkx
	}
	function zle-line-finish () {
		echoti rmkx
	}
	zle -N zle-line-init
	zle -N zle-line-finish
fi

# => Emacs mode --------------------------------------------------------------------------------------------------- {{{1

bindkey -e

# => Ctrl-r ------------------------------------------------------------------------------------------------------- {{{1

bindkey '^r' history-incremental-search-backward                               # Search backward incrementally for a specified string. The string may begin with ^ to anchor the search to the beginning of the line.

# => PageUp, PageDown --------------------------------------------------------------------------------------------- {{{1

if [[ "${terminfo[kpp]}" != "" ]]; then
	bindkey "${terminfo[kpp]}" up-line-or-history
fi
if [[ "${terminfo[knp]}" != "" ]]; then
	bindkey "${terminfo[knp]}" down-line-or-history
fi

# => Arrow-Up, Arrow-Down ----------------------------------------------------------------------------------------- {{{1

if [[ "${terminfo[kcuu1]}" != "" ]]; then
	autoload -U up-line-or-beginning-search
	zle -N up-line-or-beginning-search
	bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search                   # Start typing + [Up-Arrow] - fuzzy find history forward
fi
if [[ "${terminfo[kcud1]}" != "" ]]; then
	autoload -U down-line-or-beginning-search
	zle -N down-line-or-beginning-search
	bindkey "${terminfo[kcud1]}" down-line-or-beginning-search                 # Start typing + [Down-Arrow] - fuzzy find history backward
fi

# => Home, End ---------------------------------------------------------------------------------------------------- {{{1

if [[ "${terminfo[khome]}" != "" ]]; then
	bindkey "${terminfo[khome]}" beginning-of-line
fi
if [[ "${terminfo[kend]}" != "" ]]; then
	bindkey "${terminfo[kend]}"  end-of-line
fi

# => menuselect mode: Shift-Tab, Ctrl-h, Ctrl-j, Ctrl-k, Ctrl-l --------------------------------------------------- {{{1

if [[ "${terminfo[kcbt]}" != "" ]]; then
	bindkey -M menuselect "${terminfo[kcbt]}" reverse-menu-complete            # Move through the completion menu backwards
fi

bindkey -M menuselect '^h' backward-char
bindkey -M menuselect '^j' down-line-or-history
bindkey -M menuselect '^k' up-line-or-history
bindkey -M menuselect '^l' forward-char

# => Ctrl-X Ctrl-E ------------------------------------------------------------------------------------------------ {{{1

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line                                               # Edit the current command line in $EDITOR

# => Alt-D -------------------------------------------------------------------------------------------------------- {{{1

bindkey '\ed' copy-prev-shell-word                                             # Copy and paste previous shell word
