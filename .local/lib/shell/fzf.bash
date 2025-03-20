# vim: filetype=sh foldmethod=marker

# shellcheck disable=SC2034

if [[ -n "$BASH" ]]; then
	export SHELL="$BASH" # enforce bash for all fzf sub shells, even if default shell is not bash
fi

DEFAULT_FZF_KEYS='A-p:preview C-r:reload C-y:yank'

function fzf-exec() {
	local default_fzf_cmd_options=(
		--ansi
		--bind="alt-B:execute(${VISUAL:-${EDITOR:-vi}} '$0')"
		--bind="alt-b:execute-silent(python3 -mwebbrowser {2})"
		--bind="alt-p:toggle-preview,ctrl-s:toggle-sort,ctrl-t:toggle-track"
		--bind="ctrl-d:half-page-down,ctrl-u:half-page-up,home:top"
		--bind="ctrl-e:toggle-preview-wrap,ctrl-n:preview-down,ctrl-p:preview-up"
		--bind="ctrl-m:execute-silent(true)"
		--bind="ctrl-r:reload-sync($FZF_RELOAD_CMD)"
		--bind="ctrl-w:backward-kill-word,esc:cancel"
		--bind="ctrl-y:execute-silent(echo -n {1} | clipcopy)"
		--delimiter="\t"
		--header-lines=1
		--listen
		--preview-window="right:60%:border-left:wrap:hidden"
		--reverse
		--scroll-off=4
		--tabstop=4
	)

	fzf "${default_fzf_cmd_options[@]}" "$@"
}

function fzf-exec-multi() {
	local default_fzf_cmd_options_multi=(
		--bind="tab:toggle-out,shift-tab:toggle-in,ctrl-a:toggle-all"
		--multi
	)

	fzf-exec "${default_fzf_cmd_options_multi[@]}" "$@"
}
