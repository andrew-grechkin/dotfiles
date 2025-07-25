# vim: filetype=sh
# shellcheck disable=SC2034

RSYNC_DEFAULT_PARAMS=(
	--exclude="#recycle"
	--exclude="#snapshot"
	--exclude=".Trash-*"
	--exclude="@eaDir"
	--exclude=".local/share/containers"
	--hard-links
	--human-readable
	--info=stats
	--sparse
)

if [[ "${IS_NAS:-}" != "1" ]]; then
	RSYNC_DEFAULT_PARAMS+=(
		--open-noatime
		--info=nonreg0
	)
fi

RSYNC_COPY_PARAMS=(
	--archive
	--one-file-system
	--partial
	--xattrs
)

RSYNC_MOVE_PARAMS=(
	"${RSYNC_COPY_PARAMS[@]}"
	--remove-source-files
)

RSYNC_NAS_PARAMS_COMMON=(
	--no-group
	--no-owner
	--rsh=ssh
)

RSYNC_INFO_TTY=(
	--info=progress2
	--itemize-changes
)

RSYNC_INFO_FILE=(
	--itemize-changes
)

if [[ -t 1 ]]; then
	RSYNC_INFO=("${RSYNC_INFO_TTY[@]}")
else
	RSYNC_INFO=("${RSYNC_INFO_FILE[@]}")
fi

RSYNC_DIFF_PARAMS_COMMON=(
	--delete
	--dry-run
	--itemize-changes
	--one-file-system
	--recursive
	--links
)

RSYNC_DIFF_PARAMS=(
	"${RSYNC_DIFF_PARAMS_COMMON[@]}"
	--times
	--omit-dir-times
)

RSYNC_DIFF_PARAMS_CS=(
	"${RSYNC_DIFF_PARAMS_COMMON[@]}"
	--checksum
	--ignore-times
)
