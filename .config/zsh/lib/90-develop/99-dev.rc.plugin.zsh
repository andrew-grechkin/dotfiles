# vim: filetype=zsh foldmethod=marker
# shellcheck source=/dev/null

# => local development activation --------------------------------------------------------------------------------- {{{1

function dev-activate() {
    local pth="$1"

    if [[ -r "$pth.asc" ]]; then
        if gpg --verify "$pth.asc" "$pth" 2>/dev/null; then
            __ACTIVE_DIR_ENV="$PWD"
            __ACTIVE_DIR_SNAPSHOT=$(mktemp --tmpdir="${XDG_RUNTIME_DIR?:only XDG, /tmp is not safe for this}" --suffix=dev-rc)
            declare -px > "$__ACTIVE_DIR_SNAPSHOT"
            perl -E 'say for keys %ENV' > "${__ACTIVE_DIR_SNAPSHOT}.names"

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

# python repo managed by poetry
function py-poetry-activate() {
    if command -v poetry &>/dev/null; then
        # TODO: make reset if proven to work good for dev.rc
        source-file "$(poetry env info -p)/bin/activate" && umask 0002 && return 0
    fi

    return 1
}

# python repo managed by venv
function py-venv-activate() {
    local venv_path='.venv/bin/activate'

    [[ -r "$venv_path" ]] || {
        echo "preparing python venv for the first time" >&2
        python -m venv .venv && source "$venv_path"

        python -m pip install -r 'requirements.txt'

        if [[ -r 'test/requirements.txt' ]]; then
            python -m pip install -r 'test/requirements.txt'
        fi
    }

    # TODO: make reset if proven to work good for dev.rc
    source "$venv_path" && umask 0002 && return 0
}

# => cd hook ------------------------------------------------------------------------------------------------------ {{{1

function on-cwd-change() {
    local -A matches=(
        dev       'dev.rc|../dev.rc|.envrc'
        js        '.nvmrc|package.json|project.json'
        perl      'cpanfile|dist.ini'
        py-poetry 'poetry.lock'
        py-venv   'requirements.txt'
    )
    local file files tool

    if [[ -n "$__ACTIVE_DIR_ENV" && ! "$PWD" =~ ^${__ACTIVE_DIR_ENV}(/|$) ]]; then
        if [[ -r "$__ACTIVE_DIR_SNAPSHOT" ]]; then

            while read -r var; do
                unset "$var"
            done < <(perl -E 'my %o=map {chomp; $_ => 1} <<>>; say for grep {!$o{$_}} keys %ENV' < "${__ACTIVE_DIR_SNAPSHOT}.names")

            source "$__ACTIVE_DIR_SNAPSHOT" 2>/dev/null

            rm -f -- "$__ACTIVE_DIR_SNAPSHOT" "${__ACTIVE_DIR_SNAPSHOT}.names"
        fi

        unset __ACTIVE_DIR_ENV __ACTIVE_DIR_SNAPSHOT
    fi

    if [[ -n "$__ACTIVE_DIR_ENV" ]]; then
        return 0
    fi

    for tool in "${(@ko)matches}"; do
        IFS="|" read -A files <<< "${matches[$tool]}"
        for file in "${files[@]}"; do
            [[ -r "$file" ]] && "$tool-activate" "$file" >&2 && return 0
        done
    done
}

function on-prompt-show() {
    # NOTE: this runs only once on terminal launch
    add-zsh-hook -d precmd on-prompt-show

    add-zsh-hook    chpwd  on-cwd-change
    on-cwd-change
}

add-zsh-hook precmd on-prompt-show
