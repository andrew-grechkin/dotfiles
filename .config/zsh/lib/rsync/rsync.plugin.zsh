COMMON_PARAMS='--sparse --exclude="@eaDir" --exclude="#recycle" --exclude="#snapshot" --exclude=".Trash-*" -Hah'

alias               cpr="rsync ${COMMON_PARAMS} -P"
alias               mvr="rsync ${COMMON_PARAMS} -P --remove-source-files"
alias               upr="rsync ${COMMON_PARAMS} -P -u"

alias        rsync-copy="rsync ${COMMON_PARAMS} --info=progress2"
alias        rsync-move="rsync ${COMMON_PARAMS} --info=progress2 --remove-source-files"
alias      rsync-update="rsync ${COMMON_PARAMS} --info=progress2 -u"
alias rsync-synchronize="rsync ${COMMON_PARAMS} --info=progress2 -uXx --delete"
alias        rsync-diff="rsync ${COMMON_PARAMS} --dry-run -i     -uXx --delete"

alias     rsync-sudo-copy="sudo -E -s rsync ${COMMON_PARAMS} --info=progress2 -e 'ssh -l $USER'"
alias     rsync-sudo-sync="sudo -E -s rsync ${COMMON_PARAMS} --info=progress2 -e 'ssh -l $USER' -uXx --delete"
alias   rsync-sudo-update="sudo -E -s rsync ${COMMON_PARAMS} --info=progress2 -e 'ssh -l $USER' -u"

unset COMMON_PARAMS
