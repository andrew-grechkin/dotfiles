function assert() {
    local name="$1"
    local description="$2"
    local input="$3"
    local expected="$4"
    local result="$5"

    jq -ne --argjson result "$result" --argjson expected "$expected" '$result == $expected' &> /dev/null && return 0

    # shellcheck disable=SC2016
    local args=(
        '{name: $name, description: $description, input: $input, expected: $expected, got: $result}'
        --arg description "$description"
        --arg name "$name"
        --argjson expected "$expected"
        --argjson input "$input"
        --argjson result "$result"
    )

    jq -n "${args[@]}"

    return 1
}

function tests() {
    local func="$1"
    local filter="$2"
    local input_json="$3"
    local expected_json="$4"
    local description="${5:-}"

    local args=(
        -L "${HOME}/.local/lib/jq"
        -ncS
        --argjson input "$input_json"
        "$filter"
    )

    # shellcheck disable=SC2034
    assert "$func" "$description" "$input_json" "$expected_json" "$(jq "${args[@]}")" || declare -g FAILED=1
}
