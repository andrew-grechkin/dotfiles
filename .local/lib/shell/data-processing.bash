# vim: filetype=sh

source "$HOME/.local/lib/shell/color.bash"

function join-with-tabs() {
	local IFS=$'\t';
	echo -e "$*"
}

function json-array-to-tsv() {
	local sort_by="$1"
	shift
	local jq_fields=("$@")

	local col_names jq_filter field
	for field in "${jq_fields[@]}"; do
		if [[ "$field" =~ ^[[:alnum:]_] ]]; then
			IFS=";" read -r <<< "$field" key value color
		else # support explicit separator passed as the first character
			IFS="${field:0:1}" read -r <<< "${field:1}" key value color
		fi

		col_names+=("$key")
		if [[ -n "${color:-}" ]]; then
			jq_filter+=("${FG[$color]}${value}${FX[reset]}")
		else
			jq_filter+=("$value")
		fi
	done

	{
		echo -e "$(join-with-tabs "${col_names[@]}")"
		jq -r "$sort_by | .[] | \"$(join-with-tabs "${jq_filter[@]}")\""
	} | column --table --separator=$'\t' --output-separator=$'\t'
}
