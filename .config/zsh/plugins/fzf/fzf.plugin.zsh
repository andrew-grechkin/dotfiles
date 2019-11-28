# vim: syntax=zsh foldmethod=marker

# => Load fzf (key bindings, completion) ------------------------------------------------------------------------- {{{1

for F in '/usr/share/fzf/key-bindings.zsh' "$XDG_CONFIG_HOME/fzf/key-bindings.zsh"
do
	source-file "$F" && break
done

for F in '/usr/share/fzf/completion.zsh' "$XDG_CONFIG_HOME/fzf/completion.zsh"
do
	source-file "$F" && break
done

# => Settings ---------------------------------------------------------------------------------------------------- {{{1

# Use ~~ as the trigger sequence instead of the default **
#export FZF_COMPLETION_TRIGGER='~~'

# Options to fzf command
#export FZF_COMPLETION_OPTS='+c -x'

function _fzf_compgen_path() {
	_fzf_compgen_helper "$1" 'f'
}

function _fzf_compgen_dir() {
	_fzf_compgen_helper "$1" 'd'
}

# => Setup commands ---------------------------------------------------------------------------------------------- {{{1

export FZF_DEFAULT_COMMAND='_fzf_command_helper'
export FZF_CTRL_T_COMMAND="_fzf_command_helper"
export FZF_ALT_C_COMMAND='_fzf_compgen_helper $(pwd) d'

# => Setup options ----------------------------------------------------------------------------------------------- {{{1

PREVIEW='
	b() {(file -bi "$1" | grep "charset=binary") &>/dev/null && (hexdump -C "$1" || true)};
	t() {pygmentize -O style=monokai -f console256 -g "$1" || bat --style=numbers --color=always "$1" || cat "$1"};
	f() {b "$1" || t "$1"}
	d() {[[ -d "$1" ]] && (tree -C "$1" || true)};
	p() {stat "$1"; echo -n "  Type: "; file -b "$1"; echo; (d "$1" || f "$1") 2>&1};
	p {} | head -n 100
'
export FZF_DEFAULT_OPTS=" \
	--bind 'f1:toggle-preview' --bind 'f2:toggle-preview-wrap' --bind 'home:top' \
	--bind 'ctrl-y:execute-silent(echo {} | xclip -i -sel p -f | xclip -i -sel c)+abort' \
	--bind 'f4:execute:(\$EDITOR   {} < /dev/tty > /dev/tty 2>&1)' \
	--bind 'f3:execute:(\$PAGER    {} > /dev/tty 2>&1)' \
	--bind 'ctrl-h:execute:(hexdump -C {} | \$PAGER > /dev/tty 2>&1)' \
	--bind 'ctrl-b:execute:(binwalk    {} | \$PAGER > /dev/tty 2>&1)' \
	--bind 'ctrl-t:execute:(sha1sum    {} | \$PAGER > /dev/tty 2>&1)' \
	--bind 'ctrl-g:execute:(md5sum     {} | \$PAGER > /dev/tty 2>&1)' \
	--preview-window=right:78:hidden --preview '${PREVIEW}' \
"
export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS"
export FZF_TMUX=1
