function gl-redefine-vars() {
	if [[ -z "${GL_JOBS:-}" ]]; then
		GL_JOBS=4

		[[ -x "$(command -v nproc)" ]] && { GL_JOBS="$(nproc)"; }
		export GL_JOBS
	fi
	export GL_PER_PAGE=100

	if git-in-repo; then
		if [[ -z "${GL_ROOT:-}" ]]; then
			GL_ROOT=$(git rev-parse --show-superproject-working-tree --show-toplevel | head -1)
			export GL_ROOT
		fi

		if [[ -z "${GL_BRANCH:-}" ]]; then
			GL_BRANCH=$(git rev-parse --verify --abbrev-ref HEAD 2>/dev/null)
			export GL_BRANCH
		fi

		if [[ -z "${GL_PROJECT:-}" || -z "${GL_HOST:-}" ]]; then
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
		fi
		export GL_HOST GL_PROJECT GL_REMOTE
	fi
}

function gl-required-vars() {
	GL_API='api/v4'
	export GL_HOST="${GL_HOST:-gitlab.com}"

	if [[ -z "${GITLAB_PERSONAL_TOKEN:-}" ]]; then
		if [[ -x "$(command -v pass)" ]]; then
			if res=$(pass show "personal/${GL_HOST}" 2>/dev/null | head -1); then
				GITLAB_PERSONAL_TOKEN="$res"
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
}; [[ -n "${BASH:-}" ]] && export -f gl-required-vars

function gl-http-request() {
	if [[ "$1" =~ ^/ ]]; then
		local verb="GET"
		local uri="$1"
		shift
	else
		local verb="$1"
		local uri="$2"
		shift 2
	fi

	gl-required-vars

	local gl_common_xh_options=(
		"accept: application/json"
		"private-token: ${GITLAB_PERSONAL_TOKEN? is required to access ${GL_HOST?is required}}"
		--check-status
		--ignore-stdin
		--no-follow
	)
	xh "$verb" "https://$GL_HOST/${GL_API}$uri" "${gl_common_xh_options[@]}" "$@"
}; [[ -n "${BASH:-}" ]] && export -f gl-http-request

function gl-http-get-all-pages() {
	local uri headers pages max_pages
	max_pages="3"
	uri="$1"
	headers=$(gl-http-request HEAD "$uri" --print=h | headers_to_json)
	pages=$(jq -r '."x-total-pages"' <<<"$headers")
	seq "$((pages > max_pages ? max_pages : pages))" \
		| xargs -rI{} -P0 bash -c "gl-http-request '${uri}&page={}' | jq -cS '.[]' | mbuffer -q" \
		| jq -cn '[inputs]'
}; [[ -n "${BASH:-}" ]] && export -f gl-http-get-all-pages

function url_encode() {
	printf %s "$1" | jq -Rr @uri
}; [[ -n "${BASH:-}" ]] && export -f url_encode

function headers_to_json() {
	sort -u | grep -P '^[[:alnum:]_\-]+:\s' \
		| jq -nR '[inputs | split(": ") | {key: (.[0] | ascii_downcase), value: .[1]}] | from_entries'
}; [[ -n "${BASH:-}" ]] && export -f headers_to_json

# => branches ----------------------------------------------------------------------------------------------------- {{{1

function gl-branches-clean() {
	gl-http-request DELETE "/projects/$(url_encode "$1")/repository/merged_branches"
}

function gl-branches-get() {
	# https://docs.gitlab.com/ee/api/branches.html#list-repository-branches
	if [[ -n "${2:-}" ]]; then
		gl-http-request "/projects/$(url_encode "$1")/repository/branches/$(url_encode "$2")" \
			| jq '[.]'
	else
		gl-http-request "/projects/$(url_encode "$1")/repository/branches?per_page=$GL_PER_PAGE"
	fi
}

function gl-branch-create() {
	# https://docs.gitlab.com/ee/api/branches.html#create-repository-branch
	&>/dev/stderr echo "Creating branch: $2 (from $3)"
	gl-http-request POST "/projects/$(url_encode "$1")/repository/branches?branch=$2&ref=$3"
}

function gl-branch-delete() {
	# https://docs.gitlab.com/ee/api/branches.html#delete-repository-branch
	&>/dev/stderr echo "Deleting branch: $2 ($1)"
	gl-http-request DELETE "/projects/$(url_encode "$1")/repository/branches/$2"
}

function gl-branch-diff() {
	head=$(2>/dev/null git fetch --no-tags --porcelain "$GL_REMOTE" HEAD | perl -nal -E'say $F[2]')
	>/dev/null git fetch --no-tags --porcelain "$GL_REMOTE" "$1"
	git show --color=always --pretty=fuller --no-patch 'FETCH_HEAD'
	echo
	git diff --color=always --stat "$head...FETCH_HEAD"
	git diff "$head...FETCH_HEAD"
}

# => mrs ---------------------------------------------------------------------------------------------------------- {{{1

function gl-approvals-get() {
	# https://docs.gitlab.com/ee/api/merge_request_approvals.html#merge-request-level-mr-approvals
	gl-http-request "/projects/$(url_encode "$1")/merge_requests/$2/approvals"
}

function gl-mr-diff() {
	head=$(2>/dev/null git fetch --no-tags --porcelain "$GL_REMOTE" HEAD | perl -nal -E'say $F[2]')
	if res=$(git fetch --no-tags --porcelain "$GL_REMOTE" "merge-requests/$1/head" 2>/dev/stdout); then
		git show --color=always --pretty=fuller --no-patch 'FETCH_HEAD'
		echo
		git diff --color=always --stat "$head...FETCH_HEAD"
		git diff "$head...FETCH_HEAD"
	else
		&>/dev/stderr cat <<< "$res"
		&>/dev/stderr echo
		&>/dev/stderr echo "Unable to fetch MR branch: merge-requests/$1/head"
		&>/dev/stderr echo "    MR might be just empty"
	fi
}

function gl-mr-get() {
	# https://docs.gitlab.com/ee/api/merge_requests.html#get-single-mr
	gl-http-request "/projects/$(url_encode "$1")/merge_requests/$2"
}

function gl-mrs-get() {
	# https://docs.gitlab.com/ee/api/merge_requests.html#list-project-merge-requests
	gl-http-get-all-pages "/projects/$(url_encode "$1")/merge_requests?per_page=${GL_PER_PAGE}${query:-}"
}

function gl-mr-approve() {
	# https://docs.gitlab.com/ee/api/merge_request_approvals.html#approve-merge-request
	gl-http-request POST "/projects/$(url_encode "$1")/merge_requests/$2/$3"
}

function gl-mr-create() {
	# https://docs.gitlab.com/ee/api/merge_requests.html#create-mr
	gl-http-request POST "/projects/$(url_encode "$1")/merge_requests" "title=$2" "source_branch=$3" "target_branch=$4" "remove_source_branch=true"
}

function gl-mr-merge() {
	# https://docs.gitlab.com/ee/api/merge_requests.html#merge-a-merge-request
	&>/dev/stderr echo "Merging MR: $2"
	gl-http-request PUT "/projects/$(url_encode "$1")/merge_requests/$2/merge"
}

function gl-mr-rebase() {
	# https://docs.gitlab.com/ee/api/merge_requests.html#rebase-a-merge-request
	gl-http-request PUT "/projects/$(url_encode "$1")/merge_requests/$2/rebase"
}

function gl-mr-notes() {
	# https://docs.gitlab.com/ee/api/notes.html#list-all-merge-request-notes
	gl-http-request "/projects/$(url_encode "$1")/merge_requests/$2/notes"
}

# => pipelines ---------------------------------------------------------------------------------------------------- {{{1

function gl-pipelines-mr-get() {
	# https://docs.gitlab.com/ee/api/merge_requests.html#list-merge-request-pipelines
	gl-http-request "/projects/$(url_encode "$1")/merge_requests/$2/pipelines?per_page=${GL_PER_PAGE}&order_by=id&sort=desc${query:-}"
}

function gl-pipelines-get() {
	# https://docs.gitlab.com/ee/api/pipelines.html#list-project-pipelines
	gl-http-get-all-pages "/projects/$(url_encode "$1")/pipelines?per_page=${GL_PER_PAGE}&order_by=id&sort=desc${query:-}"
}

function gl-pipeline-get() {
	# https://docs.gitlab.com/ee/api/pipelines.html#get-a-single-pipeline
	gl-http-request "/projects/$(url_encode "$1")/pipelines/$2"
}

function gl-pipeline-cancel() {
	# https://docs.gitlab.com/ee/api/pipelines.html#cancel-a-pipelines-jobs
	gl-http-request POST "/projects/$(url_encode "$1")/pipelines/$2/cancel"
}

function gl-pipeline-retry() {
	# https://docs.gitlab.com/ee/api/pipelines.html#retry-jobs-in-a-pipeline
	gl-http-request POST "/projects/$(url_encode "$1")/pipelines/$2/retry"
}

# => jobs --------------------------------------------------------------------------------------------------------- {{{1

function gl-do-jobs-get() {
	# https://docs.gitlab.com/ee/api/jobs.html#list-pipeline-jobs
	gl-http-request "/projects/$(url_encode "$1")/pipelines/$3/jobs?per_page=${GL_PER_PAGE}${query:-}" \
		| jq -c '.[]'
}

function gl-do-bridges-get() {
	# https://docs.gitlab.com/ee/api/jobs.html#list-pipeline-trigger-jobs
	gl-http-request "/projects/$(url_encode "$1")/pipelines/$3/bridges?per_page=${GL_PER_PAGE}${query:-}" \
		| jq -c '.[]'
}

function gl-do-all-jobs-get() {
	# >/dev/stderr echo "gl-do-all-jobs-get: $*"
	gl-do-jobs-get "$1" "$2" "$3"
	bridges=$(gl-do-bridges-get "$1" "$2" "$3")
	echo "$bridges"

	# recursive get all jobs from children pipelines
	export -f gl-do-jobs-get gl-do-bridges-get gl-do-all-jobs-get
	# shellcheck disable=SC2016
	jq -r 'if .downstream_pipeline then .downstream_pipeline | "\(.project_id)/mr/\(.id)" else empty end' <<<"$bridges" \
		| xargs -rI% -P0 bash -c 'IFS="/" read -r -a parts <<< "%"; gl-do-all-jobs-get "${parts[@]}" | mbuffer -q'
}

function gl-jobs-get() {
	gl-do-all-jobs-get "$1" "$2" "$3" \
		| jq -cn '[inputs] | sort_by(.pipeline.id, .created_at)'
}

function gl-job-get() {
	# https://docs.gitlab.com/ee/api/jobs.html#get-a-single-job
	gl-http-request "/projects/$(url_encode "$1")/jobs/$2"
}

function gl-job-cancel() {
	# https://docs.gitlab.com/ee/api/jobs.html#cancel-a-job
	gl-http-request POST "/projects/$(url_encode "$1")/jobs/$2/cancel"
}

function gl-job-retry() {
	# https://docs.gitlab.com/ee/api/jobs.html#retry-a-job
	gl-http-request POST "/projects/$(url_encode "$1")/jobs/$2/retry"
}

function gl-job-run() {
	# https://docs.gitlab.com/ee/api/jobs.html#run-a-job
	gl-http-request POST "/projects/$(url_encode "$1")/jobs/$2/play"
}

function gl-job-log() {
	# https://docs.gitlab.com/ee/api/jobs.html#get-a-log-file
	&>/dev/stderr echo "Fetching logs..."
	gl-http-request "/projects/$(url_encode "$1")/jobs/$2/trace" \
		| perl -lpE 's/\r/\n/g'
}

function gl-job-download-artifacts() {
	# https://docs.gitlab.com/ee/api/job_artifacts.html#get-job-artifacts
	&>/dev/stderr echo "Downloading artifacts..."
	gl-http-request "/projects/$(url_encode "$1")/jobs/$2/artifacts" --follow
}

# => commits ------------------------------------------------------------------------------------------------------ {{{1

function gl-commit-create() {
	# https://docs.gitlab.com/ee/api/commits.html#create-a-commit-with-multiple-files-and-actions
	gl-http-request POST "/projects/$(url_encode "$1")/repository/commits" --print=HBhbm @"$2"
}

# => groups ------------------------------------------------------------------------------------------------------- {{{1

function gl-groups-list() {
	# https://docs.gitlab.com/ee/api/projects.html#search-for-projects-by-name
	gl-http-request "/groups/$(url_encode "$1")/projects?per_page=$GL_PER_PAGE&include_subgroups=true&simple=true&order_by=id&sort=asc"
}
