# vim: filetype=sh
# shellcheck disable=SC2034

ansi_reset="\033[m"

function join() {
	local IFS=$'\t';
	echo -e "$*"
}

function json-array-to-tsv() {
	sort_by="$1"
	shift
	jq_fields=("$@")

	col_names=()
	jq_filter=()
	for field in "${jq_fields[@]}"; do
		IFS=";" read -r -a keyval <<< "$field"
		col_names+=("${keyval[0]}")
		jq_filter+=("${keyval[1]}")
	done

	{
		echo -e "$(join "${col_names[@]}")"
		jq -r "$sort_by | .[] | \"$(join "${jq_filter[@]}")\""
	} | tsv-align
}
