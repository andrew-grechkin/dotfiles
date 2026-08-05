# zsh has built-in completion on `mux` as tmuxinator
# dropping it first
unset -f _tmuxinator &>/dev/null
compdef -d mux &>/dev/null

# NOTE: the bundled just completion is a piece of garbage, it spits out all the commands and options onto screen
# not only the recipes, so there is no other option than to replace it with a proper one
unset -f _clap_dynamic_completer_just &>/dev/null
unset -f _just &>/dev/null
compdef -d just &>/dev/null

_generic_justfile_completions() {
    # _describe -'recipes' recipes
    # _files
    # _describe -o 'options' options

    local curcontext="$curcontext" state line
    local cmd="${words[1]}"

    # dynamically fetch justfile recipes for whatever command called this function
    local jq_filter='.recipes[] | select(.name != "default" and .private != true) | "\(.name):\(.doc // "")"'
    local -a recipes
    recipes=("${(f)"$($cmd --json 2>/dev/null | jq -r "$jq_filter" 2>/dev/null)"}")

    local options=(
        "--check[Run --fmt in 'check' mode]"
        {-n,--dry-run}'[Print what just would do without doing it]'
        '--explain[Print recipe doc comment before running it]'
        {-g,--global-justfile}'[Use global justfile]'
        '--list-submodules[List recipes in submodules]'
        "--no-aliases[Don't show aliases in list]"
        '--no-cache[Bypass recipe cache]'
        "--no-deps[Don't run recipe dependencies]"
        "--no-dotenv[Don't load .env file]"
        '--time[Print recipe execution time]'
        '--timestamp[Print recipe command timestamps]'
        {-u,--unsorted}'[Return list and summary entries in source order]'
        '--unstable[Enable unstable features]'
        '(-v --verbose -q --quiet)'{-q,--quiet}'[Quiet mode]'
        '(-q --quiet)*'{-v,--verbose}'[Increase verbosity]'
        '--yes[Automatically confirm all recipes]'
        {-h,--help}'[Print help]'
        {-V,--version}'[Print version]'
    )

    local commands=(
        '--changelog[Print changelog]'
        '--choose[Select recipe]'
        '--dump[Print justfile]'
        {-e,--edit}'[Edit the justfile]'
        '--evaluate[Evaluate and print all variables]'
        '--fmt[Format and overwrite justfile]'
        '--groups[List recipe groups]'
        '--init[Initialize new justfile in project root]'
        {-l,--list}'[List all available recipes]'
        '--man[Print man page]'
        '--summary[List names of available recipes]'
        '--variables[List names of variables]'
        # '-f[File]:file:_files'
    )
    # TODO: handle options and commands differently (because they should be used in different state)
    local args=(
        "1:recipe:{_describe 'recipes' recipes}"
        '::files3:_files'
    )
    _arguments -s -S "${options[@]}" "${commands[@]}" "${args[@]}"
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
        book
        cue
        dib
        doc
        kube
        markdown
        mk
        mux
        oci
        pl
        system
        video
        yk

        docker-images
        gg
        gitlab gl
        harness
        jfrog
        redis-tui

        aur-model
        chrome-model
        drive-model
        family-model
        gemini-model
        gitlab-model
        harness-model
        jfrog-model
        people-model
        redis-model
        sheets-model
        tf-model

        artifactory
        bks
        loki
        passport-model
        rb-model
        sd-model

        menu-aur
    )

    local it
    for it in "${executables[@]}"; do
        register_justfile_completion "$it"
    done

    unset -f register_justfile_completion
}
