# vim: filetype=zsh foldmethod=marker

# => aliases ----------------------------------------------------------------------------------------------------- {{{1

alias pip-ensure='python -m ensurepip --default-pip'
alias pip-upgrade='pip freeze | pip install --upgrade -r /dev/stdin'

# => functions --------------------------------------------------------------------------------------------------- {{{1

function activate-local-python() {
	if (( $+commands[poetry] )); then
		local PYTHON_LOCAL="$(poetry env info -p)"
	else                                                                           # fallback onto venv if poetry is not available
		local PYTHON_LOCAL=${1:-${XDG_CACHE_HOME}/python3}
		[[ ! -f "$PYTHON_LOCAL/bin/activate" ]] && python3 -m venv "$PYTHON_LOCAL"
	fi

	source-file "$PYTHON_LOCAL/bin/activate"
}
