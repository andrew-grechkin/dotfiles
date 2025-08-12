GIT_DIR=$(git rev-parse --git-dir)
GIT_URL=$(git config --get remote.origin.url)
GIT_WORK_TREE=$(git rev-parse --show-toplevel)

export GIT_DIR GIT_URL GIT_WORK_TREE

# run every executable hook in "<dir>/<name>.d", passing the hook arguments
function dispatch() {
    local dir=$1 name=$2 message=$3
    shift 3

    [[ -d "$dir/$name.d" ]] || return 0

    local ecode=0
    local hook
    for hook in "$dir/$name.d"/*; do
        [[ -x "$hook" ]] || continue
        echo "$message $hook" >&2
        "$hook" "$@" || ecode=$?
    done

    return "$ecode"
}
