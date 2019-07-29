# vim: syntax=zsh foldmethod=marker

# => Load fzf ---------------------------------------------------------------------------------------------------- {{{1

for F in '/usr/share/fzf/key-bindings.zsh' "$XDG_CONFIG_HOME/fzf/key-bindings.zsh"
do
	source-file "$F" && break
done

for F in '/usr/share/fzf/completion.zsh' "$XDG_CONFIG_HOME/fzf/completion.zsh"
do
	source-file "$F" && break
done

# local  GIT_LIST_FILES="git ls-files -co --recurse-submodules --exclude-standard"
local  GIT_LIST_FILES="git ls-files -co --exclude-standard"
local         FD_LIST="fd -HL --exclude=.git"
local FIND_LIST_FILES="find -type f | grep -v '/\.git'"

export FZF_DEFAULT_COMMAND="(${GIT_LIST_FILES} || ${FD_LIST} --type f || ${FIND_LIST_FILES}) 2>/dev/null"
#export FZF_DEFAULT_COMMAND="(git ls-tree -r --name-only HEAD) 2> /dev/null"
export FZF_DEFAULT_OPTS="--preview '(bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -40'"

export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
export FZF_CTRL_T_OPTS="--preview '(bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -40' \
	--bind 'ctrl-v:execute(vim {}),ctrl-y:execute-silent(echo {} | xclip -i -sel p -f | xclip -i -sel c)+abort'"

export FZF_ALT_C_COMMAND="(${FD_LIST} --type d || find -type d | grep -v '/\.git') 2>/dev/null"

# => Settings ---------------------------------------------------------------------------------------------------- {{{1

# Use ~~ as the trigger sequence instead of the default **
#export FZF_COMPLETION_TRIGGER='~~'

# Options to fzf command
#export FZF_COMPLETION_OPTS='+c -x'

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
function _fzf_compgen_path() {
	(\
		fd -HL --exclude=.git --type f "$1" || \
		find "$1" -type f | grep -v '/\.git' \
	) 2>/dev/null
}

# Use fd to generate the list for directory completion
function _fzf_compgen_dir() {
	(\
		fd -HL --exclude=.git --type d "$1" || \
		find "$1" -type d | grep -v '/\.git' \
	) 2>/dev/null
}
