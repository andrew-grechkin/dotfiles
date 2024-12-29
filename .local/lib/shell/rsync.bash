# vim: filetype=sh
# shellcheck disable=SC2034

RSYNC_DEFAULT_PARAMS=(
	--exclude="#recycle"
	--exclude="#snapshot"
	--exclude=".Trash-*"
	--exclude="@eaDir"
	--sparse
)

RSYNC_COPY_PARAMS=(
	--partial
	-HahXx
)

RSYNC_MOVE_PARAMS=(
	--partial
	--remove-source-files
	-HahXx
)

RSYNC_NAS_PARAMS_COMMON=(
	--info=progress2
	--no-group
	--no-owner
	--omit-dir-times
	--rsh=ssh
)

RSYNC_DIFF_PARAMS_COMMON=(
	--delete
	--dry-run
	-i
)

RSYNC_DIFF_PARAMS=(
	"${RSYNC_DIFF_PARAMS_COMMON[@]}"
	-HhrtlDXx
)

RSYNC_DIFF_PARAMS_CS=(
	"${RSYNC_DIFF_PARAMS_COMMON[@]}"
	--checksum
	--ignore-times
	-hrlDXx
)
