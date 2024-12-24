# shellcheck disable=SC2034

function gl-redefine-vars() {
	if [[ -z "${GL_JOBS:-}" ]]; then
		GL_JOBS=4

		[[ -x "$(command -v nproc)" ]] && { GL_JOBS="$(nproc)"; }
	fi
	export GL_JOBS="$GL_JOBS"

	if [[ -z "${GL_BRANCH:-}" ]]; then
		GL_BRANCH=$(git rev-parse --verify --abbrev-ref HEAD 2>/dev/null)
		export GL_BRANCH
	fi

	if [[ -z "${GL_ROOT:-}" ]]; then
		GL_ROOT=$(git rev-parse --show-superproject-working-tree --show-toplevel | head -1)
		export GL_ROOT
	fi

	if [[ -z "${GL_PROJECT:-}" ]]; then
		if git-in-repo; then
			set +e
			# REMOTE=$(git config --local --get "branch.$current_branch.remote" 2>/dev/null || git show-ref 2>/dev/null | grep -Po '(?<=\\brefs/remotes/)[^\\/]+(?=/HEAD\\b)' | head -1)
			GL_REMOTE="$(git remote -v | perl -nE 'my ($remote) = m/(\w+)\s+(?:.*?gitlab)/; say $remote if $remote' | head -1)"
			if [[ -z "$GL_REMOTE" ]]; then
				>/dev/stderr echo "unable to detect gitlab related remote for this repo among:"
				>/dev/stderr git remote -v
				exit 1
			fi
			repo_url="$(git config --get "remote.${GL_REMOTE}.url")"
			if [[ -z "$repo_url" ]]; then
				>/dev/stderr echo "unable to detect repo url for remote: $GL_REMOTE"
				exit 1
			fi
			IFS=":" read -r -a parts <<< "$repo_url"
			GL_HOST="${parts[0]#*@}"
			GL_PROJECT="${parts[1]%.git}"
			set -e
			export GL_HOST GL_PROJECT GL_REMOTE
		else
			>/dev/stderr echo "undefined project"
			exit 1
		fi
	fi

	export GL_API='api/v4'
	export GL_HOST="${GL_HOST:-gitlab.com}"

	if [[ -z "${GITLAB_PERSONAL_TOKEN:-}" ]]; then
		if [[ -x "$(command -v pass)" ]]; then
			if res=$(pass show "personal/${GL_HOST}" 2>/dev/null); then
				export GITLAB_PERSONAL_TOKEN="$res"
			fi
		fi
	fi
	if [[ -z "${GITLAB_PERSONAL_TOKEN:-}" ]]; then
		local token_file="${XDG_CONFIG_HOME:-~/.config}/gitlab/${GL_HOST}.token"
		if [[ -r "$token_file" ]]; then
			GITLAB_PERSONAL_TOKEN=$(cat "$token_file")
		else
			>/dev/stderr echo "Please provide gitlab token with 'api' permission as one of:"
			>/dev/stderr echo "  - pass personal/${GL_HOST}"
			>/dev/stderr echo "  - GITLAB_PERSONAL_TOKEN env variable"
			>/dev/stderr echo "  - $token_file file"
			exit 1
		fi
	fi
	export GITLAB_PERSONAL_TOKEN
}

function gl-define-xh-options() {
	GL_COMMON_XH_OPTIONS=(
		"accept: application/json"
		"private-token: $GITLAB_PERSONAL_TOKEN"
		--check-status
		--ignore-stdin
		--no-follow
	)
	# GL_COMMON_CURL_OPTIONS=(
	# 	-s
	# 	-H "accept: application/json"
	# 	-H "private-token: ${GITLAB_PERSONAL_TOKEN:-}"
	# )
}

function url_encode() {
	printf %s "$1" | jq -Rr @uri
}

function gl-branches-clean() {
	gl-define-xh-options
	local http_fetch_command=(
		xhs
		DELETE
		"${GL_HOST}/$GL_API/projects/$(url_encode "$1")/repository/merged_branches"
		"${GL_COMMON_XH_OPTIONS[@]}"
	)
	"${http_fetch_command[@]}"
}

function gl-branches-get() {
	# https://docs.gitlab.com/ee/api/branches.html#list-repository-branches
	gl-define-xh-options
	local http_fetch_command=(
		xhs
		"${GL_HOST}/$GL_API/projects/$(url_encode "$1")/repository/branches?per_page=100"
		"${GL_COMMON_XH_OPTIONS[@]}"
	)
	"${http_fetch_command[@]}"
}

function gl-branch-delete() {
	# https://docs.gitlab.com/ee/api/branches.html#delete-repository-branch
	gl-define-xh-options
	local http_fetch_command=(
		xhs
		DELETE
		"$GL_HOST/$GL_API/projects/$(url_encode "$1")/repository/branches/$2"
		"${GL_COMMON_XH_OPTIONS[@]}"
	)
	"${http_fetch_command[@]}"
}

function gl-mr-approvals-get() {
	# https://docs.gitlab.com/ee/api/merge_request_approvals.html#merge-request-level-mr-approvals
	gl-define-xh-options
	local http_fetch_command=(
		xhs
		"$GL_HOST/$GL_API/projects/$(url_encode "$1")/merge_requests/$2/approvals"
		"${GL_COMMON_XH_OPTIONS[@]}"
	)
	"${http_fetch_command[@]}"
}

function gl-mr-get() {
	# https://docs.gitlab.com/ee/api/merge_requests.html#get-single-mr
	gl-define-xh-options
	local http_fetch_command=(
		xhs
		"${GL_HOST}/$GL_API/projects/$(url_encode "$1")/merge_requests/$2"
		"${GL_COMMON_XH_OPTIONS[@]}"
	)
	"${http_fetch_command[@]}"
}

function gl-mr-approve() {
	# https://docs.gitlab.com/ee/api/merge_request_approvals.html#approve-merge-request
	gl-define-xh-options
	local http_fetch_command=(
		xhs
		POST
		"$GL_HOST/$GL_API/projects/$(url_encode "$1")/merge_requests/$2/$3"
		"${GL_COMMON_XH_OPTIONS[@]}"
	)
	"${http_fetch_command[@]}"
}

function gl-mr-create() {
	# https://docs.gitlab.com/ee/api/merge_requests.html#create-mr
	gl-define-xh-options
	local http_fetch_command=(
		xhs
		POST
		"${GL_HOST}/$GL_API/projects/$(url_encode "$1")/merge_requests"
		"${GL_COMMON_XH_OPTIONS[@]}"
		"title=$2"
		"source_branch=$3"
		"target_branch=$4"
		"remove_source_branch=true"
	)
	"${http_fetch_command[@]}"
}

function gl-mr-list() {
	# https://docs.gitlab.com/ee/api/merge_requests.html#list-project-merge-requests
	gl-define-xh-options
	local http_fetch_command=(
		xhs
		"${GL_HOST}/$GL_API/projects/$(url_encode "$1")/merge_requests$2"
		"${GL_COMMON_XH_OPTIONS[@]}"
	)
	"${http_fetch_command[@]}"
}

function gl-mr-merge() {
	# https://docs.gitlab.com/ee/api/merge_requests.html#merge-a-merge-request
	gl-define-xh-options
	local http_fetch_command=(
		xhs
		PUT
		"$GL_HOST/$GL_API/projects/$(url_encode "$1")/merge_requests/$2/merge"
		"${GL_COMMON_XH_OPTIONS[@]}"
	)
	"${http_fetch_command[@]}"
}

function gl-commit-create() {
	# https://docs.gitlab.com/ee/api/commits.html#create-a-commit-with-multiple-files-and-actions
	gl-define-xh-options
	local http_fetch_command=(
		xhs
		POST
		"${GL_HOST}/$GL_API/projects/$(url_encode "$1")/repository/commits"
		"${GL_COMMON_XH_OPTIONS[@]}"
		@"$2"
	)
	"${http_fetch_command[@]}"
}
