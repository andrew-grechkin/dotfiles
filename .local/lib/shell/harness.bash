function ha-api-auth() {
	export HARNESS_ORG_ID="${HARNESS_ORG_ID:-default}"
	export HARNESS_API_HOST="${HARNESS_API_HOST:-app.harness.io}"
	export HARNESS_ORG_ID="${HARNESS_ORG_ID:-$(pass show personal/harness-org-id 2>/dev/null)}"
	export HARNESS_ACCOUNT="${HARNESS_ACCOUNT:-$(pass show personal/harness-account 2>/dev/null)}"
	export HARNESS_API_KEY="${HARNESS_API_KEY:-$(pass show personal/harness 2>/dev/null)}"
	export HA_ACCQ="accountIdentifier=$HARNESS_ACCOUNT"
	export HA_DEFQ="accountIdentifier=$HARNESS_ACCOUNT&orgIdentifier=$HARNESS_ORG_ID"
}; [[ -n "${BASH:-}" ]] && export -f ha-api-auth

function ha-http-request() {
	if [[ "$1" =~ ^/ ]]; then
		local verb="GET"
		local uri="$1"
		shift
	else
		local verb="$1"
		local uri="$2"
		shift 2
	fi

	ha-api-auth

	local ha_common_xh_options=(
		"accept: application/json"
		"harness-account: $HARNESS_ACCOUNT"
		"x-api-key: $HARNESS_API_KEY"
		--check-status
		--ignore-stdin
		--no-follow
	)
	uri=$(eval "echo \"$uri\"")
	xh "$verb" "https://${HARNESS_API_HOST}$uri" "${ha_common_xh_options[@]}" "$@"
}; [[ -n "${BASH:-}" ]] && export -f ha-http-request

# => projects ----------------------------------------------------------------------------------------------------- {{{1

function ha-project-get() {
	ha-http-request "/ng/api/projects/${1}?\$HA_DEFQ"
}

function ha-project-get-by-name() {
	ha-http-request "/ng/api/projects/$(ha-project-name-to-id "$1")?\$HA_DEFQ"
}

function ha-project-name-to-id() {
	ha-http-request "/ng/api/projects?\$HA_DEFQ&pageSize=100&searchTerm=$1" | jq -r --arg n "$1" '.data.content[] | select(.project.name == $n) | .project.identifier'
}

function ha-project-list() {
	# https://apidocs.harness.io/tag/Project/#operation/getProjectList
	cache="${TMPDIR:-/tmp}/harness-projects.cache.jsonl"
	if [[ -r "$cache" ]] && test "$(find "$cache" -mmin '-60')"; then
		cat "$cache"
	else
		local uri="/ng/api/projects?\$HA_DEFQ&pageSize=2000"
		local page0 total i
		page0=$(ha-http-request "$uri&pageIndex=0")
		total=$(jq -r '.data.totalPages' <<<"$page0")
		{
			jq -c '.data.content[]' <<< "$page0"
			for (( i=1; i<=total; i++ )); do
				ha-http-request "$uri&pageIndex=$i" | jq -c '.data.content[]'
			done
		} | tee "$cache"
	fi | jq -cn '[inputs]'
}

function ha-project-create() {
	# https://apidocs.harness.io/tag/Project#operation/postProject
	(
		set -e
		ha-redefine-vars
		body=$(jq -cnR --arg n "$1" --arg i "${1//-/_}" --arg o "$HARNESS_ORG_ID" '
		{project: {
			identifier: $i,
			name: $n,
			orgIdentifier: $o
			}}'
		)
		ha-http-request POST "/ng/api/projects?\$HA_DEFQ" --raw "$body"
		echo
		# https://apidocs.harness.io/tag/File-Store#operation/create
		# "${http_cmd[@]::${#http_cmd[@]}-1}" -XPOST "$ha_url/ng/api/file-store$HA_DEFQ&projectIdentifier=${1//-/_}" \
			# 	-H 'Content-Type: multipart/form-data' \
			# 	-F identifier=services \
			# 	-F name=services \
			# 	-F type=FOLDER \
			# 	-F parentIdentifier=Root
		# echo
	)
}

function ha-project-remove() {
	ha-http-request DELETE "/ng/api/projects/${1}?\$HA_DEFQ"
}

function ha-project-remove-by-name() {
	ha-http-request DELETE "/ng/api/projects/$(ha-project-name-to-id "$1")?\$HA_DEFQ" && echo
}

function ha-project-get-services() {
	ha-http-request "/ng/api/servicesV2?\$HA_DEFQ&projectIdentifier=$1" | jq -c '.data.content'
}

function ha-project-get-services-by-name() {
	ha-http-request "/ng/api/servicesV2?\$HA_DEFQ&projectIdentifier=$(ha-project-name-to-id "$1")"
}

function ha-project-if-empty-by-name() {
	id=$(ha-project-name-to-id "$1")
	[[ -z "$id" ]] && return 0
	res=$(ha-http-request "/ng/api/servicesV2?\$HA_DEFQ&projectIdentifier=$id")
	jq -r --arg n "$1" 'if (.status == "SUCCESS" and .data.totalItems == 0) then $n else empty end' <<<"$res"
}

function ha-project-if-not-empty-by-name() {
	id=$(ha-project-name-to-id "$1")
	[[ -z "$id" ]] && return 0
	res=$(ha-http-request "/ng/api/servicesV2?\$HA_DEFQ&projectIdentifier=$id")
	jq -r --arg n "$1" 'if (.status == "SUCCESS" and .data.totalItems > 0) then $n else empty end' <<<"$res"
}

# => user-groups -------------------------------------------------------------------------------------------------- {{{1

function ha-user-group-list() {
	# https://apidocs.harness.io/tag/User-Group#operation/getUserGroupList
	cache="${TMPDIR:-/tmp}/harness-user-groups.cache.jsonl"
	if [[ -r "$cache" ]] && test "$(find "$cache" -mmin '-60')"; then
		cat "$cache"
	else
		local uri="/ng/api/user-groups?\${HA_ACCQ}&filterType=INCLUDE_CHILD_SCOPE_GROUPS&pageSize=2000"
		local page0 total i
		page0=$(ha-http-request "$uri&pageIndex=0")
		total=$(jq -r '.data.totalPages' <<<"$page0")
		{
			jq -c '.data.content[]' <<< "$page0"
			for (( i=1; i<=total; i++ )); do
				ha-http-request "$uri&pageIndex=$i" | jq -c '.data.content[]'
			done
		} | tee "$cache"
		# 	seq "$(jq '.data.totalPages' <<< "$res")" | xargs -rI% -t bash -c "ha-http-request "'/ng/api/user-groups\?pageSize=1000\&$HA_DEFQ\&pageIndex=%'" | jq '.data.content | length'"
	fi | jq -cn '[inputs]'
}

function ha-user-group-get-by-id() {
	# https://apidocs.harness.io/tag/User-Group#operation/getUserGroup
	if [[ -n "${2:-}" && "$2" != "null" ]]; then
		local org_idq="orgIdentifier=$2"
	fi
	ha-http-request "/ng/api/user-groups/$1?\$HA_ACCQ&${org_idq:-}"
}

function ha-user-group-users-list-by-id() {
	# https://apidocs.harness.io/tag/User-Group#operation/getUserListInUserGroup
	if [[ -n "${2:-}" && "$2" != "null" ]]; then
		local org_idq="orgIdentifier=$2"
	fi
	ha-http-request POST "/ng/api/user-groups/$1/users?\$HA_ACCQ&${org_idq:-}" --raw '{"parentFilter": "NO_PARENT_SCOPES"}' | tee /tmp/blah
	# jq '(.data.content = .data.content | sort_by(.name)) | .'
}
