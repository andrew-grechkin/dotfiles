register_argc_completion() {
    local cmd="$1"
    if (( ${+commands[$cmd]} )); then
        compdef _gnu_generic "$cmd"
    fi
}

() {
    local executables=(
        emu
        git-credential-pass
        git-credential-pass-cache
        git-x-amend
        jq-repl
        memoize
        menu-yt
        show
        tap
        tsv-show
    )

    local it
    for it in "${executables[@]}"; do
        register_argc_completion "$it"
    done

    unset -f register_argc_completion
}
