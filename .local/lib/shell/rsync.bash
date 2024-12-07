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
	-Hah
)

RSYNC_MOVE_PARAMS=(
	--partial
	--remove-source-files
	-Hah
)

RSYNC_DIFF_PARAMS=(
	--delete
	--dry-run
	--no-group
	--no-owner
	--omit-dir-times
	-HhrtlDXx
	-i
)
