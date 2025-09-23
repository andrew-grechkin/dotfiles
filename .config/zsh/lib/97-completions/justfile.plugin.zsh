# zsh has built-in completion on `mux` as tmuxinator
# dropping it first
unset -f _tmuxinator &>/dev/null
compdef -d mux &>/dev/null

# increase the limit of copletion suggestions without annoying `are you sure?` question
LISTMAX=300

_generic_justfile_completions() {
    local -a subcmds
    local cmd=$words[1]

    # Dynamically fetch justfile recipes for whatever command called this function
    jq_filter='.recipes[] | select(.name != "default" and .private != true) | "\(.name):\(.doc // "")"'
    subcmds=("${(f)"$($cmd --json 2>/dev/null | jq -r "$jq_filter" 2>/dev/null)"}")

    flags=(
        '--choose:Select recipe'
        '--edit:Edit the justfile'
        '--evaluate:Evaluate and print all variables'
        '--groups:List recipe groups'
        '--list:List all available recipes'
    )

    _describe -t subcommands 'recipes' subcmds
    _describe -t flags 'flags' flags
    _files
}

register_justfile_completion() {
    local cmd=$1
    if (( ${+commands[$cmd]} )); then
        compdef _generic_justfile_completions "$cmd"
    fi
}

register_justfile_completion gemini-api
register_justfile_completion gitlab-api
register_justfile_completion mux
unset -f register_justfile_completion
