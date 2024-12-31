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

	if [[ -z "${GL_PROJECT:-}" || -z "${GL_HOST:-}" ]]; then
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
			[[ -z "${GL_HOST:-}" ]]    && GL_HOST="${parts[0]#*@}"
			[[ -z "${GL_PROJECT:-}" ]] && GL_PROJECT="${parts[1]%.git}"
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
	GL_PER_PAGE=100
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

# => branches ----------------------------------------------------------------------------------------------------- {{{1

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
	if [[ -n "${2:-}" ]]; then
		local http_fetch_command=(
			xhs
			"${GL_HOST}/$GL_API/projects/$(url_encode "$1")/repository/branches/$(url_encode "$2")"
			"${GL_COMMON_XH_OPTIONS[@]}"
		)
		"${http_fetch_command[@]}" | jq '[.]'
	else
		local http_fetch_command=(
			xhs
			"${GL_HOST}/$GL_API/projects/$(url_encode "$1")/repository/branches?per_page=$GL_PER_PAGE"
			"${GL_COMMON_XH_OPTIONS[@]}"
		)
		"${http_fetch_command[@]}"
	fi
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
	&>/dev/stderr echo "Deleting branch: $2"
	"${http_fetch_command[@]}"
}

# => mrs ---------------------------------------------------------------------------------------------------------- {{{1

function gl-approvals-get() {
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

function gl-mrs-get() {
	gl-define-xh-options
	# https://docs.gitlab.com/ee/api/merge_requests.html#list-project-merge-requests
	local http_fetch_command=(
		xhs
		"${GL_HOST}/$GL_API/projects/$(url_encode "$1")/merge_requests?per_page=${GL_PER_PAGE}${query:-}"
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

function gl-mr-rebase() {
	# https://docs.gitlab.com/ee/api/merge_requests.html#rebase-a-merge-request
	gl-define-xh-options
	local http_fetch_command=(
		xhs
		PUT
		"$GL_HOST/$GL_API/projects/$(url_encode "$1")/merge_requests/$2/rebase"
		"${GL_COMMON_XH_OPTIONS[@]}"
	)
	"${http_fetch_command[@]}"
}

function gl-mr-notes() {
	# https://docs.gitlab.com/ee/api/notes.html#list-all-merge-request-notes
	gl-define-xh-options
	local http_fetch_command=(
		xhs
		"$GL_HOST/$GL_API/projects/$(url_encode "$1")/merge_requests/$2/notes"
		"${GL_COMMON_XH_OPTIONS[@]}"
	)
	"${http_fetch_command[@]}"
}

# => pipelines ---------------------------------------------------------------------------------------------------- {{{1

function gl-pipelines-get() {
	# https://docs.gitlab.com/ee/api/pipelines.html#list-project-pipelines
	# https://docs.gitlab.com/ee/api/merge_requests.html#list-merge-request-pipelines
	gl-define-xh-options
	local http_fetch_command=(
		xhs
		"${GL_HOST}/$GL_API/projects/$(url_encode "$1")/merge_requests/$2/pipelines?per_page=${GL_PER_PAGE}&order_by=updated_at&sort=asc${query:-}"
		"${GL_COMMON_XH_OPTIONS[@]}"
	)
	"${http_fetch_command[@]}"
}

function gl-pipeline-get() {
	# https://docs.gitlab.com/ee/api/pipelines.html#get-a-single-pipeline
	gl-define-xh-options
	local http_fetch_command=(
		xhs
		"${GL_HOST}/$GL_API/projects/$(url_encode "$1")/pipelines/$2"
		"${GL_COMMON_XH_OPTIONS[@]}"
	)
	"${http_fetch_command[@]}"
}

function gl-pipeline-cancel() {
	# https://docs.gitlab.com/ee/api/pipelines.html#cancel-a-pipelines-jobs
	gl-define-xh-options
	local http_fetch_command=(
		xhs
		POST
		"${GL_HOST}/$GL_API/projects/$(url_encode "$1")/pipelines/$2/cancel"
		"${GL_COMMON_XH_OPTIONS[@]}"
	)
	"${http_fetch_command[@]}"
}

function gl-pipeline-retry() {
	# https://docs.gitlab.com/ee/api/pipelines.html#retry-jobs-in-a-pipeline
	gl-define-xh-options
	local http_fetch_command=(
		xhs
		POST
		"${GL_HOST}/$GL_API/projects/$(url_encode "$1")/pipelines/$2/retry"
		"${GL_COMMON_XH_OPTIONS[@]}"
	)
	"${http_fetch_command[@]}"
}

# => jobs --------------------------------------------------------------------------------------------------------- {{{1

function gl-jobs-get() {
	# https://docs.gitlab.com/ee/api/jobs.html#list-pipeline-jobs
	gl-define-xh-options
	local http_fetch_command=(
		xhs
		"${GL_HOST}/$GL_API/projects/$(url_encode "$1")/pipelines/$3/jobs?per_page=${GL_PER_PAGE}${query:-}"
		"${GL_COMMON_XH_OPTIONS[@]}"
	)
	"${http_fetch_command[@]}"
}

function gl-job-get() {
	# https://docs.gitlab.com/ee/api/jobs.html#get-a-single-job
	gl-define-xh-options
	local http_fetch_command=(
		xhs
		"${GL_HOST}/$GL_API/projects/$(url_encode "$1")/jobs/$2"
		"${GL_COMMON_XH_OPTIONS[@]}"
	)
	"${http_fetch_command[@]}"
}

function gl-job-cancel() {
	# https://docs.gitlab.com/ee/api/jobs.html#cancel-a-job
	gl-define-xh-options
	local http_fetch_command=(
		xhs
		POST
		"${GL_HOST}/$GL_API/projects/$(url_encode "$1")/jobs/$2/cancel"
		"${GL_COMMON_XH_OPTIONS[@]}"
	)
	"${http_fetch_command[@]}"
}

function gl-job-retry() {
	# https://docs.gitlab.com/ee/api/jobs.html#retry-a-job
	gl-define-xh-options
	local http_fetch_command=(
		xhs
		POST
		"${GL_HOST}/$GL_API/projects/$(url_encode "$1")/jobs/$2/retry"
		"${GL_COMMON_XH_OPTIONS[@]}"
	)
	"${http_fetch_command[@]}"
}

function gl-job-run() {
	# https://docs.gitlab.com/ee/api/jobs.html#run-a-job
	gl-define-xh-options
	local http_fetch_command=(
		xhs
		POST
		"${GL_HOST}/$GL_API/projects/$(url_encode "$1")/jobs/$2/run"
		"${GL_COMMON_XH_OPTIONS[@]}"
	)
	"${http_fetch_command[@]}"
}

function gl-job-log() {
	# https://docs.gitlab.com/ee/api/jobs.html#get-a-log-file
	gl-define-xh-options
	local http_fetch_command=(
		xhs
		"${GL_HOST}/$GL_API/projects/$(url_encode "$1")/jobs/$2/trace"
		"${GL_COMMON_XH_OPTIONS[@]}"
	)
	"${http_fetch_command[@]}" | perl -lpE 's/\r/\n/g'
}

# => commits ------------------------------------------------------------------------------------------------------ {{{1

function gl-commit-create() {
	# https://docs.gitlab.com/ee/api/commits.html#create-a-commit-with-multiple-files-and-actions
	gl-define-xh-options
	local http_fetch_command=(
		xhs
		POST
		"${GL_HOST}/$GL_API/projects/$(url_encode "$1")/repository/commits"
		"${GL_COMMON_XH_OPTIONS[@]}"
		--print=HBhbm
		@"$2"
	)
	"${http_fetch_command[@]}"
}
