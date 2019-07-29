function activate-local-python() {
	local PYTHON_LOCAL=${1:-${XDG_CACHE_HOME}/python3}
	[[ ! -f "$PYTHON_LOCAL/bin/activate" ]] && python3 -m venv "$PYTHON_LOCAL"

	source-file "$PYTHON_LOCAL/bin/activate"
}

function activate-local-python2() {
	local PYTHON_LOCAL=${1:-${XDG_CACHE_HOME}/python2}
	[[ ! -f "$PYTHON_LOCAL/bin/activate" ]] && \
		pip2 install --ignore-installed --install-option="--prefix=$PYTHON_LOCAL" virtualenv && \
		PYTHONPATH="$PYTHON_LOCAL/lib/python2.7/site-packages:$PYTHONPATH" "$PYTHON_LOCAL/bin/virtualenv" "$PYTHON_LOCAL"

	source-file "$PYTHON_LOCAL/bin/activate"
}
