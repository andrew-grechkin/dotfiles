# zsh has built-in completion on `mux` as tmuxinator
# dropping it first
unset -f _tmuxinator &>/dev/null
compdef -d mux &>/dev/null

unset -f _clap_dynamic_completer_just &>/dev/null
unset -f _just &>/dev/null
compdef -d just &>/dev/null

_generic_justfile_completions() {
    # _describe -'recipes' recipes
    # _files
    # _describe -o 'options' options

    local curcontext="$curcontext" state line
    local cmd="${words[1]}"

    # Dynamically fetch justfile recipes for whatever command called this function
    local jq_filter='.recipes[] | select(.name != "default" and .private != true) | "\(.name):\(.doc // "")"'
    local -a recipes
    recipes=("${(f)"$($cmd --json 2>/dev/null | jq -r "$jq_filter" 2>/dev/null)"}")

    local options=(
        '(-v --verbose -q --quiet)-q[Quiet mode]'
        '(-v --verbose -q --quiet)--quiet[Quiet mode]'
        '(-q --quiet)*-v[Increase verbosity]'
        '(-q --quiet)*--verbose[Increase verbosity]'
        '--choose[Select recipe]'
        '--edit[Edit the justfile]'
        '--evaluate[Evaluate and print all variables]'
        '--groups[List recipe groups]'
        '--list[List all available recipes]'
        # '-f[File]:file:_files'
    )
    local args=(
        "1:recipe:{_describe 'recipes' recipes}"
        '::files3:_files'
    )
    _arguments -s -S "${options[@]}" "${args[@]}"
}

register_justfile_completion() {
    local cmd="$1"
    if (( ${+commands[$cmd]} )); then
        compdef _generic_justfile_completions "$cmd"
    fi
}

() {
    local executables=(
        just

        arch
        audio
        bom
        cue
        dib
        doc
        markdown
        mk
        mux
        oci
        pl
        video
        yk

        docker-images
        gg
        gitlab gl
        harness
        jfrog

        drive-api
        gemini-api
        gitlab-api
        harness-api
        jfrog-api
        people-model
        redis-model
        sheets-api
        tf-api

        passport-model
        rb-model
        sd-model
    )

    local it
    for it in "${executables[@]}"; do
        register_justfile_completion "$it"
    done

    unset -f register_justfile_completion
}
