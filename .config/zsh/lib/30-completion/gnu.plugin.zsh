register_gnu_completion() {
    local cmd="$1"
    if (( ${+commands[$cmd]} )); then
        compdef _gnu_generic "$cmd"
    fi
}

() {
    local executables=(
        colored-md
    )

    local it
    for it in "${executables[@]}"; do
        register_gnu_completion "$it"
    done

    unset -f register_gnu_completion
}
