# vim: filetype=zsh foldmethod=marker
# shellcheck source=/dev/null

# => local development activation --------------------------------------------------------------------------------- {{{1

function dev-activate() {
    local pth="$1"

    if [[ -r "$pth.asc" ]]; then
        if gpg --verify "$pth.asc" "$pth" 2>/dev/null; then
            source "$pth" && umask 0002 && return 0
        else
            echo "unable to setup local dev environment: signature is wrong for $pth" >&2
        fi
    else
        echo "unable to setup local dev environment: found and skipped unsigned $pth" >&2
    fi

    return 1
}

function js-activate() {
    return 1 # tbd
}

function perl-activate() {
    return 1 # tbd
}

# Python repo managed by poetry
function py-poetry-activate() {
    if command -v poetry &>/dev/null; then
        source-file "$(poetry env info -p)/bin/activate" && umask 0002 && return 0
    fi

    return 1
}

# Python repo managed by venv
function py-venv-activate() {
    local venv_path='.venv/bin/activate'

    [[ -r "$venv_path" ]] || {
        echo "Preparing Python venv for the first time"
        python -m venv .venv && source "$venv_path"

        python -m pip install -r 'requirements.txt'

        if [[ -r 'test/requirements.txt' ]]; then
            python -m pip install -r 'test/requirements.txt'
        fi
    }

    source "$venv_path" && umask 0002 && return 0
}

# => cd hook ------------------------------------------------------------------------------------------------------ {{{1

function on-cwd-change() {
    local -A matches=(
        dev       'dev.rc|../dev.rc'
        js        '.nvmrc|package.json|project.json'
        perl      'cpanfile|dist.ini'
        py-poetry 'poetry.lock'
        py-venv   'requirements.txt'
    )
    local file files tool

    for tool in "${(@ko)matches}"; do
        IFS="|" read -A files <<< "${matches[$tool]}"
        for file in "${files[@]}"; do
            [[ -r "$file" ]] && "$tool-activate" "$file" >&2 && return 0
        done
    done
}

function on-prompt-show() {
    # this one is necessary only once on the start of the shell (becasue chpwd is not called on start)
    add-zsh-hook -d precmd on-prompt-show

    add-zsh-hook    chpwd  on-cwd-change
    on-cwd-change
}

add-zsh-hook precmd on-prompt-show
