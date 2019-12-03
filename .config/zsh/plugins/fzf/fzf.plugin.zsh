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

# Use \ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='\'

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
	f() {b "$1" || show-file "$1"}
	d() {[[ -d "$1" ]] && (tree -C "$1" || true)};
	p() {stat "$1"; echo -n "  Type: "; file -b "$1"; echo; (d "$1" || f "$1") 2>&1};
	p {} | head -n 100
'
export FZF_DEFAULT_BINDS=(
	--bind 'ctrl-d:page-down'
	--bind 'ctrl-u:page-up'
	--bind 'f1:toggle-preview'
	--bind 'f2:toggle-preview-wrap'
	--bind 'home:top'
	--bind 'ctrl-y:execute-silent(echo {} | xclip -i -sel p -f | xclip -i -sel c)+abort'
)
export FZF_FILE_BINDS=(
	--bind 'f3:execute((show-dir {} || show-file {} ) | $PAGER > /dev/tty 2>&1)'
	--bind 'f4:execute($EDITOR {} < /dev/tty > /dev/tty 2>&1)'
	--bind 'ctrl-h:execute((show-dir {} || hexdump -C {}) | $PAGER > /dev/tty 2>&1)'
	--bind 'ctrl-b:execute((show-dir {} || binwalk {}) | $PAGER > /dev/tty 2>&1)'
	--bind 'ctrl-t:execute((show-dir {} || sha1sum {}) | $PAGER > /dev/tty 2>&1)'
	--bind 'ctrl-g:execute((show-dir {} || md5sum {}) | $PAGER > /dev/tty 2>&1)'
)
export FZF_FILE_PREVIEW=(
	--preview-window=right:78:hidden
	--preview="${PREVIEW}"
)
export FZF_DEFAULT_OPTS=$(printf " '%s'" ${FZF_DEFAULT_BINDS[@]} ${FZF_FILE_BINDS[@]} ${FZF_FILE_PREVIEW[@]})
export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS"
export FZF_TMUX=1

# => fzf ssh (override default one) ------------------------------------------------------------------------------ {{{1

function _ssh_config_parsed_hosts() {
	local SSH_CONF=(~/.ssh/config ~/.ssh/config.d/* /etc/ssh/ssh_config)
	command perl -mList::Util=uniq -nE 'm/[*?%#]/x and next; if (m/^.*host(?:name|\s)+(.*)/i) {push @hosts, split(m/ |,/, $1 =~ s/"//gr)}; END {say for uniq sort @hosts}' "${SSH_CONF[@]}"
}

function _ssh_known_parsed_hosts() {
	command grep -oE '^[[a-z0-9.,:-]+' ~/.ssh/known_hosts | tr ',' '\n' | tr -d '[' | awk '{print $1 " " $1}'
}

function _ssh_hosts_parsed_hosts() {
	command grep -v '^\s*\(#\|$\)' /etc/hosts | command grep -Fv '0.0.0.0'
}

function _fzf_complete_ssh() {
	_fzf_complete '+m' "$@" < <(
		command cat <(
			_ssh_config_parsed_hosts
			_ssh_known_parsed_hosts
			_ssh_hosts_parsed_hosts
		) | awk '{if (length($2) > 0) {print $2}}' | sort -u
	)
}
