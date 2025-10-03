function compaudit-detect() {
    emulate -L zsh
    setopt EXTENDED_GLOB
    local my_uid=$UID
    local dir parent file
    local -A checked_parents

    echo "=== Scanning \$fpath, parent dirs, and completion entries ==="

    # The leading '-' in the qualifiers makes the tests operate on symlink
    # targets instead of the symlinks themselves (which are always mode 777).
    for dir in "${fpath[@]}"; do
        [[ -d "$dir" ]] || continue

        # 1. Check if the directory itself is group/world writable or owned by someone else
        for item in "$dir"(N-^u0u"$my_uid",-W,-f:g+w:); do
            echo "[OFFENDER] fpath dir: $item"
            ls -ld "$item"
        done

        # 2. Check the immediate parent directory, like compaudit does
        parent="${dir:h}"
        if [[ -n "$parent" && -z "${checked_parents[$parent]}" ]]; then
            checked_parents[$parent]=1
            for item in "$parent"(N-^u0u"$my_uid",-W,-f:g+w:); do
                echo "[OFFENDER] Parent dir: $item"
                ls -ld "$item"
            done
        fi

        # 3. Check all completion entries inside the directory
        for file in "$dir"/*(N-^u0u"$my_uid",-W,-f:g+w:); do
            echo "[OFFENDER] Entry inside fpath: $file"
            ls -ld "$file"
        done
    done
}

function install-zsh-3rdparty() {
    (
        cd "$XDG_DATA_HOME/3rdparty" || exit
        git submodule update --init .
    )
}

function install-distrobox() {
    curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --prefix ~/.local
}

function login-as() {
    sudo runuser -lPs "$SHELL" "${1?user name must be provided}"
}

function run-as() {
    sudo -u "${1?user name must be provided}" -i
}

# => proxy -------------------------------------------------------------------------------------------------------- {{{1

function enable-proxy() {
    export all_proxy="http://$PROXY_FDQN:$PROXY_PORT"
    export http_proxy="http://$PROXY_FDQN:$PROXY_PORT"
    export https_proxy="http://$PROXY_FDQN:$PROXY_PORT"
    export no_proxy="localhost,localaddress,127.0.0.1"
}

function disable-proxy() {
    unset all_proxy
    unset http_proxy
    unset https_proxy
    export no_proxy="*"
}

# => docker ------------------------------------------------------------------------------------------------------- {{{1

function dw() {
    image="registry.gitlab.com/andrew-grechkin/dotfiles/scripts"
    name="$(basename "$image")"

    argv=$(getopt --name="$0" --options 'p:' --longoptions 'publish:' -- "$@")
    eval set -- "$argv"

    publish=()

    while ((1)); do
        case "$1" in
            -p | --publish) publish=(-p "$2"); shift 2 ;;
            --) shift; break ;;
        esac
    done

    [[ -t 0 && -t 1 ]] && args=(-it) || args=(-i)
    # shellcheck disable=SC2016
    args+=(
        --rm
        -e TERM -e USER -e GITLAB_TOKEN --env-merge 'PATH=${PATH}:/mnt'
        -h "$name"
        -v '.:/mnt:ro'
        "${publish[@]}"
    )

    command docker run "${args[@]}" "$image" "$@"
}

# => environment -------------------------------------------------------------------------------------------------- {{{1

function remove-all-environment() {
    unset "$(env | cut -d= -f1 | grep -v '^PATH$' | grep -v '^HOME$' | grep -v '^PWD$' | grep -v '^USER$' | grep -v '^TERM$')"
}

function export-var() {
    script=$(cat << EO_SCRIPT
export ${1?variable name is required}='$(</dev/stdin)'
EO_SCRIPT
    )

    eval "$script"
}

function export-personal-token() {
    if [[ -z "${2:-}" ]]; then
        if [[ "${1?host must be provided}" == 'gitlab.com' ]]; then
            name='GITLAB_TOKEN'
        elif [[ "$1" == 'app.harness.io' ]]; then
            name='HARNESS_TOKEN'
        elif [[ "$1" == 'app.terraform.io' ]]; then
            name='TF_BEARER'
        else
            >&2 echo "token name must be provided"
            return 1
        fi
    fi
    pass show "token/${1}/${USER}/$name" | export-var "$name"
}
