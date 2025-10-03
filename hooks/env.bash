GIT_DIR="$(git rev-parse --git-dir)"
GIT_URL="$(git config --get remote.origin.url)"
GIT_WORK_TREE="$(git rev-parse --show-toplevel)"

export GIT_DIR GIT_URL GIT_WORK_TREE
