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
	--open-noatime
	--sparse
	--info=nonreg0
)

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
)

RSYNC_INFO_FILE=(
	--itemize-changes
)

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
