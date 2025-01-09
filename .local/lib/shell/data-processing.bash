# vim: filetype=sh
# shellcheck disable=SC2034

function join-with-tabs() {
	local IFS=$'\t';
	echo -e "$*"
}

function json-array-to-tsv() {
	local sort_by="$1"
	shift
	local jq_fields=("$@")

	local col_names=()
	local jq_filter=()
	local field
	for field in "${jq_fields[@]}"; do
		IFS=";" read -r <<< "$field" key value
		col_names+=("$key")
		jq_filter+=("$value")
	done

	{
		echo -e "$(join-with-tabs "${col_names[@]}")"
		jq -r "$sort_by | .[] | \"$(join-with-tabs "${jq_filter[@]}")\""
	} | column --table --separator=$'\t' --output-separator=$'\t'
}
