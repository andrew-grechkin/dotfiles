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
	local default_fzf_cmd_options=(
		--ansi
		--bind="alt-B:execute(${VISUAL:-${EDITOR:-vi}} '$0')"
		--bind="alt-b:execute-silent(python3 -mwebbrowser {2})"
		--bind="alt-p:toggle-preview,ctrl-s:toggle-sort,ctrl-t:toggle-track"
		--bind="ctrl-d:half-page-down,ctrl-u:half-page-up,home:top"
		--bind="ctrl-e:toggle-preview-wrap,ctrl-n:preview-down,ctrl-p:preview-up"
		--bind="ctrl-l:reload-sync(${FZF_RELOAD_CMD:-$0})"
		--bind="ctrl-m:execute-silent(true)"
		--bind="ctrl-w:backward-kill-word,esc:cancel"
		--bind="ctrl-y:execute-silent(echo -n {1} | clipcopy)"
		--delimiter="\t"
		--header-lines=1
		--header="$DEFAULT_FZF_KEYS"
		--listen
		--preview-window="right:60%:border-left:wrap:hidden"
		--reverse
		--scroll-off=4
		--tabstop=4
	)

	FZF_DEFAULT_OPTS_FILE="" fzf "${default_fzf_cmd_options[@]}" "$@"
}

function fzf-exec-multi() {
	local default_fzf_cmd_options_multi=(
		--bind="tab:toggle-out,shift-tab:toggle-in,ctrl-a:toggle-all"
		--multi
	)

	fzf-exec "${default_fzf_cmd_options_multi[@]}" "$@"
}

# this is necessary because in graph mode some lines are not having commit hash
CMD_CURRENT_BRANCH='git branch --show-current'
CMD_EXTRACT_BRANCH='echo {} | grep -o "[[:xdigit:]]\{6,\}" | head -1 | xargs -r git branch --format="%(refname:short)" --contains | head -1'
CMD_EXTRACT_COMMIT='echo {} | grep -o "[[:xdigit:]]\{6,\}" | head -1 | tr -d "\n"'
CMD_EXTRACT_DESC='echo {} | grep -o "[[:xdigit:]]\{6,\}" | head -1 | xargs -r git describe --all --always --contains'
CMD_EXTRACT_REF='echo {} | grep -o "[[:xdigit:]]\{6,\}" | head -1 | xargs -r git pcommit | git ant | tee /dev/stderr | perl -lpE "m/~\d+$/ || s|^remotes\/[^\/]+\/||"'

FZF_GIT_DEFAULT_ARGS=(
	--bind="alt-I:execute(show-commit \$($CMD_EXTRACT_COMMIT) -- ${OPTIONS[*]} --show-signature | ${LOG_PAGER[*]} -s)"
	--bind="alt-b:execute-silent(git browse \$($CMD_EXTRACT_COMMIT))"
	--bind="alt-d:execute(show-commit \$($CMD_EXTRACT_COMMIT) --diff -- ${OPTIONS[*]} --show-signature | ${LOG_PAGER[*]})"
	--bind="alt-i:execute(show-commit \$($CMD_EXTRACT_COMMIT) -- ${OPTIONS[*]} --show-signature | ${LOG_PAGER[*]})"
	--bind="ctrl-m:become(grep -o '[[:xdigit:]]\{6,\}' {+f} | xargs -rn1 git pcommit | tee >(clipcopy))"
	--bind="ctrl-x:become([[ -n {q} ]] && echo {q} | tee >(clipcopy) &>/dev/stderr; cat {+f})"
	--bind="ctrl-y:execute-silent($CMD_EXTRACT_COMMIT | xargs -r git pcommit | trim-whole | clipcopy)"
	--delimiter=" "
	--header-lines=0
	--header="Enter:take A-d/i/I:diff C-x:dump A-b:browse A-p:preview"
	--no-sort
	--preview="show-commit \$($CMD_EXTRACT_COMMIT) -- ${OPTIONS[*]} | ${LOG_PAGER[*]}"
	--scheme=history
	--track
)
