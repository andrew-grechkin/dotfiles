# vim: filetype=zsh foldmethod=marker

# => local development activation --------------------------------------------------------------------------------- {{{1

# shellcheck source=/dev/null

function try-source-dev-rc() {
	pth="$1"

	if [[ -r "$pth" ]]; then
		if [[ -r "$pth.asc" ]]; then
			gpg --verify "$pth.asc" "$pth" 2>/dev/null && source "$pth"
		else
			>/dev/stderr echo "unable to setup local dev environment: found and skipped unsigned $pth"
		fi
	fi
}

function activate() {
	if [[ "${1:-}" == 'silent' ]]; then
		shift
		SILENT=1
	else
		SILENT=0
	fi

	venv_path='.venv/bin/activate'
	FILES=('dev.rc' "$venv_path" 'venv/bin/activate')

	if command git rev-parse HEAD &>/dev/null; then
		REPO_ROOT="$(git rev-parse --show-toplevel)"

		if [[ -r '.nvmrc' || -r "$REPO_ROOT/.nvmrc" ]]; then
			nvm use
			umask 0002
			return
		fi

		FILES+=("${FILES[@]/#/$REPO_ROOT/}")
		FILES+=("$REPO_ROOT/projects/deployments/dev.rc")
	fi

	for FILE in "${FILES[@]}"; do
		if [[ -r "$FILE" ]]; then
			if [[ "$FILE" =~ dev.rc$ ]]; then
				try-source-dev-rc "$FILE"
				umask 0002
				return
			elif [[ "$FILE" =~ venv/bin/activate$ ]]; then
				source "$FILE"
				umask 0002
				return
			fi
		fi
	done

	### common cases
	if [[ -r 'poetry.lock' ]]; then
		# Python repo managed by poetry
		if command -v poetry &>/dev/null; then
			PYTHON_LOCAL="$(poetry env info -p)"
			source "$PYTHON_LOCAL/bin/activate"
			umask 0002
			return
		fi
	elif [[ -r 'requirements.txt' ]]; then
		# Python repo managed by venv

		echo "Preparing Python venv for the first time"
		python -m venv .venv && source "$venv_path"

		python -m pip install -r 'requirements.txt'
		if [[ -r 'test/requirements.txt' ]]; then
			python -m pip install -r 'test/requirements.txt'
		fi
		umask 0002
		return
	fi

	if [[ "$SILENT" != '1' ]]; then
		tput bold && tput setaf 1
		echo 'Unable to find any activation scripts'
		tput sgr0
	fi
}

# => cd hook ------------------------------------------------------------------------------------------------------ {{{1

function on-cwd-change() {
	if [[ -r '.gitignore' || -r 'Makefile' ]]                                    \
		|| [[ -r '.nvmrc' || -r 'package.json' || -r 'project.json' ]]           \
		|| [[ -r 'dev.rc' || -r '../dev.rc' || -r 'cpanfile' || -r 'dist.ini' ]] \
		|| [[ -r 'requirements.txt' ]]; then

		activate 'silent'
	fi
}

function on-prompt-show() {
	if [[ -z "${FIRST_PROMPT_PROCESSED:-}" ]]; then
		activate 'silent'
		export FIRST_PROMPT_PROCESSED="$PWD"
	fi
}

add-zsh-hook chpwd on-cwd-change
add-zsh-hook precmd on-prompt-show
