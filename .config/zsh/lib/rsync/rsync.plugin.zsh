COMMON_PARAMS='--sparse --exclude="@eaDir" --exclude="#recycle" --exclude="#snapshot" --exclude=".Trash-*"'

alias               cpr="rsync ${COMMON_PARAMS} -P -Hah"
alias               mvr="rsync ${COMMON_PARAMS} -P -Hah --remove-source-files"
alias               upr="rsync ${COMMON_PARAMS} -P -Hahu"

alias        rsync-copy="rsync ${COMMON_PARAMS} --info=progress2 -Hah"
alias        rsync-move="rsync ${COMMON_PARAMS} --info=progress2 -Hah --remove-source-files"
alias      rsync-update="rsync ${COMMON_PARAMS} --info=progress2 -Hahu"
alias rsync-synchronize="rsync ${COMMON_PARAMS} --info=progress2 -HahuXx --delete"
alias        rsync-diff="rsync ${COMMON_PARAMS} --dry-run -i     -HahuXx --delete"

unset COMMON_PARAMS
