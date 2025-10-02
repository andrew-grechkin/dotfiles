# vim: filetype=sh foldmethod=marker

# shellcheck disable=SC2034

if [[ -n "$BASH" ]]; then
    export SHELL="$BASH" # enforce bash for all fzf sub shells, even if default shell is not bash
fi

DEFAULT_FZF_KEYS='A-p:preview C-l:reload C-y:yank'
if [[ -n "$(command -v delta)"  ]]; then
    LOG_PAGER=("delta" --paging=always)
else
    LOG_PAGER=("$PAGER")
fi

function fzf-exec() {
    local transform
    transform=$(cat<<'EO_TRANSFORM'
    w="$FZF_CLICK_FOOTER_WORD"
    if [[ "$w" =~ ^F[1-9]: || "$w" =~ ^enter: ]]; then
        echo "trigger(${FZF_CLICK_FOOTER_WORD%:*})"
	elif [[ "$w" =~ ^(A|alt)-(.): ]]; then
        echo "trigger(alt-${BASH_REMATCH[2]})"
    elif [[ "$w" =~ ^(C|ctrl)-([a-z]): ]]; then
        echo "trigger(ctrl-${BASH_REMATCH[2]})"
    fi
EO_TRANSFORM
    )
    local fzf_args=(
        --ansi
        --bind="alt-B:execute:${VISUAL:-${EDITOR:-vi}} '$0'"
        --bind="alt-b:execute-silent:git web--browse {2}"
        --bind="alt-p:toggle-preview,alt-/:toggle-preview-wrap,ctrl-n:preview-down,ctrl-p:preview-up"
        --bind="alt-up:first,alt-down:last"
        --bind="click-footer:transform:$transform"
        --bind="ctrl-d:half-page-down,ctrl-u:half-page-up"
        --bind="ctrl-g:jump"
        --bind="ctrl-l:clear-screen+reload-sync:${FZF_RELOAD_CMD:-$0}"
        --bind="ctrl-s:toggle-sort,ctrl-t:toggle-track"
        --bind="ctrl-y:execute-silent:echo -n {1} | clipcopy"
        --bind="esc:become:true"
        --delimiter="\t"
        --listen
        --preview-window="right:60%:border-left:wrap:hidden"
        --reverse
        --scroll-off=4
        --tabstop=4
    )
    FZF_DEFAULT_OPTS_FILE="" fzf "${fzf_args[@]}" "$@"
}

function fzf-exec-multi() {
    local fzf_args=(
        --bind="tab:toggle-out,shift-tab:toggle-in,ctrl-a:toggle-all"
        --multi
    )
    fzf-exec "${fzf_args[@]}" "$@"
}

function fzf-files() {
    local fzf_args=(
        --bind="F3:execute:${PAGER:-less} {-1}"
        --bind="F4:execute:${VISUAL:-${EDITOR:-vi}} {-1}"
        --footer='F3:view F4:edit'
        --no-multi-line
        --preview='colored --color=always {-1}'
        --read0
    )
    fzf-exec "${fzf_args[@]}" "$@"
}

function fzf-files-multi() {
    local fzf_args=(
        --bind="F3:execute:${PAGER:-less} {-1}"
        --bind="F4:execute:${VISUAL:-${EDITOR:-vi}} {-1}"
        --footer='F3:view F4:edit'
        --no-multi-line
        --preview='colored --color=always {-1}'
        # --preview='git show --color=always HEAD:{}'
        --read0
    )
    fzf-exec-multi "${fzf_args[@]}" "$@"
}

function fzf-table() {
    local fzf_args=(
        --header-lines=1
    )
    fzf-exec "${fzf_args[@]}" "$@"
}

function fzf-table-multi() {
    local fzf_args=(
        --header-lines=1
    )
    fzf-exec-multi "${fzf_args[@]}" "$@"
}

# this is necessary because in graph mode some lines are not having commit hash
CMD_CURRENT_BRANCH='git branch --show-current'
CMD_EXTRACT_BRANCH='echo {} | grep -o "[[:xdigit:]]\{6,\}" | head -1 | xargs -r git branch --format="%(refname:short)" --contains | head -1'
CMD_EXTRACT_COMMIT='echo {} | grep -o "[[:xdigit:]]\{6,\}" | head -1 | tr -d "\n"'
CMD_EXTRACT_DESC='  echo {} | grep -o "[[:xdigit:]]\{6,\}" | head -1 | xargs -r git describe --all --always --contains'
CMD_EXTRACT_REF='   echo {} | grep -o "[[:xdigit:]]\{6,\}" | head -1 | xargs -r git pcommit | git ant2 | perl -lpE "m/~\d+$/ || s|^remotes\/[^\/]+\/||"'

FZF_GIT_DEFAULT_ARGS=(
    # --bind="load:pos(git lag | grep -Pnm1 '[^\/]HEAD' - | grep -Po '^\d+')"
    --bind="alt-I:execute(show-commit \$($CMD_EXTRACT_COMMIT) -- ${OPTIONS[*]} | ${LOG_PAGER[*]} -s)"
    --bind="alt-b:execute-silent(git browse \$($CMD_EXTRACT_COMMIT))"
    --bind="alt-c:execute(show-commit \$($CMD_EXTRACT_COMMIT) --diff -- ${OPTIONS[*]} | ${LOG_PAGER[*]})"
    --bind="alt-d:execute( { s=\$($CMD_EXTRACT_COMMIT)..HEAD; echo Explicit diff for \$s; echo; git --no-pager diff --color=always --minimal --patch --stat \$s; } | ${LOG_PAGER[*]})"
    --bind="alt-i:execute(show-commit \$($CMD_EXTRACT_COMMIT) -- ${OPTIONS[*]} | ${LOG_PAGER[*]})"
    --bind="alt-t:become(fzf-git-x-status)"
    --bind="ctrl-m:become(grep -o '[[:xdigit:]]\{6,\}' {+f} | xargs -rn1 git pcommit | clipcopy)"
    --bind="ctrl-x:become([[ -n {q} ]] && echo {q} | clipcopy >&2; cat {+f})"
    --bind="alt-y:execute-silent($CMD_EXTRACT_COMMIT | xargs -r git show -s --format=%B | trim-whole | clipcopy)"
    --bind="ctrl-y:execute-silent($CMD_EXTRACT_COMMIT | xargs -r git pcommit | trim-whole | clipcopy)"
    --bind="esc:become:true"
    --delimiter=" "
    --no-sort
    --preview="show-commit \$($CMD_EXTRACT_COMMIT) -- ${OPTIONS[*]} | ${LOG_PAGER[*]}"
    --prompt="log > "
    --scheme=history
    --tiebreak="begin,chunk"
    --track
)
FZF_GIT_DEFAULT_FOOTER='A-c: A-i: A-I:change A-d:diff C-x:dump A-t:status enter:take | C-y:yank A-y:yank A-b:browse A-p:preview'

function fzf-git() {
    local fzf_args=(
        "${FZF_GIT_DEFAULT_ARGS[@]}"
        --footer="${FZF_GIT_FOOTER_PREFIX:-}$FZF_GIT_DEFAULT_FOOTER"
    )
    fzf-exec "${fzf_args[@]}" "$@"
}

function fzf-git-multi() {
    local fzf_args=(
        "${FZF_GIT_DEFAULT_ARGS[@]}"
        --footer="${FZF_GIT_FOOTER_PREFIX:-}$FZF_GIT_DEFAULT_FOOTER"
    )
    fzf-exec-multi "${fzf_args[@]}" "$@"
}
