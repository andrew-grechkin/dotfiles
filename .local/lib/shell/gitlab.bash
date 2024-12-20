# vim: filetype=sh
# shellcheck disable=SC2034

function url_encode() {
	printf %s "$1" | jq -Rr @uri
}

if [[ -t 1 ]]; then
	INTERACTIVE=1
	PRINT_HEADER=1
else
	INTERACTIVE=0
	PRINT_HEADER=0
fi

if [[ -z "${JOBS:-}" ]]; then
	JOBS=4

	[[ -x "$(command -v nproc)" ]] && {
		JOBS="$(nproc)"
	}
fi

API='api/v4'

[[ -z "${BRANCH:-}" ]] && BRANCH=$(git rev-parse --verify --abbrev-ref HEAD 2>/dev/null)

if [[ -z "${PROJECT:-}" ]]; then
	if git-in-repo; then
		set +e
		# REMOTE=$(git config --local --get "branch.$current_branch.remote" 2>/dev/null || git show-ref 2>/dev/null | grep -Po '(?<=\\brefs/remotes/)[^\\/]+(?=/HEAD\\b)' | head -1)
		REMOTE="$(git remote -v | perl -nE 'my ($remote) = m/(\w+)\s+(?:.*?gitlab)/; say $remote if $remote' | head -1)"
		if [[ -z "$REMOTE" ]]; then
			>/dev/stderr echo "unable to detect gitlab related remote for this repo among:"
			>/dev/stderr git remote -v
			exit 1
		fi
		repo_url="$(git config --get "remote.${REMOTE}.url")"
		if [[ -z "$repo_url" ]]; then
			>/dev/stderr echo "unable to detect repo url for remote: $REMOTE"
			exit 1
		fi
		IFS=":" read -r -a parts <<< "$repo_url"
		HOST="${parts[0]#*@}"
		PROJECT="${parts[1]%.git}"
		set -e
	else
		>/dev/stderr echo "undefined project"
		exit 1
	fi
fi

HOST="${HOST:-gitlab.com}"
if [[ -z "${GITLAB_PERSONAL_TOKEN:-}" ]]; then
	if [[ -x "$(command -v pass)" ]]; then
		if res=$(pass show "personal/${HOST}" 2>/dev/null); then
			GITLAB_PERSONAL_TOKEN="$res"
		fi
	fi
fi
if [[ -z "${GITLAB_PERSONAL_TOKEN:-}" ]]; then
	token_file="${XDG_CONFIG_HOME:-~/.config}/gitlab/${HOST}.token"
	if [[ -r "$token_file" ]]; then
		GITLAB_PERSONAL_TOKEN="$(cat "$token_file")"
	else
		>/dev/stderr echo "Please provide gitlab token with 'api' permission as one of:"
		>/dev/stderr echo "  - pass personal/${HOST}"
		>/dev/stderr echo "  - GITLAB_PERSONAL_TOKEN env variable"
		>/dev/stderr echo "  - $token_file file"
		exit 1
	fi
fi

COMMON_XH_OPTIONS=(
	"accept: application/json"
	"private-token: $GITLAB_PERSONAL_TOKEN"
	--check-status
	--ignore-stdin
	--no-follow
)

COMMON_CURL_OPTIONS=(
	-s
	-H "accept: application/json"
	-H "private-token: $GITLAB_PERSONAL_TOKEN"
)
