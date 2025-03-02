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
		local silent=1
	else
		local silent=0
	fi

	local venv_path='.venv/bin/activate'
	local files=('dev.rc' "$venv_path" 'venv/bin/activate')

	if command git rev-parse HEAD &>/dev/null; then
		local repo_root="$(git rev-parse --show-toplevel)"

		files+=("${files[@]/#/$repo_root/}")
		files+=("$repo_root/projects/deployments/dev.rc")
	fi

	local file
	for file in "${files[@]}"; do
		if [[ -r "$file" ]]; then
			if [[ "$file" =~ dev.rc$ ]]; then
				try-source-dev-rc "$file"
				umask 0002
				return
			elif [[ "$file" =~ venv/bin/activate$ ]]; then
				source "$file"
				umask 0002
				return
			fi
		fi
	done

	### common cases
	if [[ -r 'poetry.lock' ]]; then
		# Python repo managed by poetry
		if command -v poetry &>/dev/null; then
			source-file "$(poetry env info -p)/bin/activate"
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

	if [[ "$silent" != '1' ]]; then
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
