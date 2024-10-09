# vim: filetype=zsh foldmethod=marker

# => exports ------------------------------------------------------------------------------------------------------ {{{1

export PYENV_ROOT="${PYENV_ROOT:-$XDG_DATA_HOME/pyenv}"

# => aliases ------------------------------------------------------------------------------------------------------ {{{1

# alias pip-ensure='python -m ensurepip --default-pip'
# alias pip-upgrade='pip freeze | pip install --upgrade -r /dev/stdin'

# => functions ---------------------------------------------------------------------------------------------------- {{{1

function activate-local-python() {
	if (( $+commands[poetry] )); then
		local PYTHON_LOCAL="$(poetry env info -p)"
	else                                                                           # fallback onto venv if poetry is not available
		local PYTHON_LOCAL=${1:-${XDG_CACHE_HOME}/python3}
		[[ ! -f "$PYTHON_LOCAL/bin/activate" ]] && python3 -m venv "$PYTHON_LOCAL"
	fi

	source-file "$PYTHON_LOCAL/bin/activate"
}

function enable-pyenv() {
	export PATH="$PYENV_ROOT/bin:$PATH"
	eval "$(pyenv init -)"
}

# => main --------------------------------------------------------------------------------------------------------- {{{1

# if (( $+commands[pyenv] )); then
# 	enable-pyenv
# fi
