COMMON_PARAMS='--sparse --exclude="@eaDir" --exclude="#recycle" --exclude="#snapshot" --exclude=".Trash-*"'
COMMON_OPTS='-Hah'

alias               cpr="rsync ${COMMON_PARAMS} ${COMMON_OPTS} -P"
alias               mvr="rsync ${COMMON_PARAMS} ${COMMON_OPTS} -P --remove-source-files"
alias               upr="rsync ${COMMON_PARAMS} ${COMMON_OPTS} -P -u"

alias           rsync-copy="rsync ${COMMON_PARAMS} ${COMMON_OPTS} --info=progress2"
alias        rsync-copy-cs="rsync ${COMMON_PARAMS} ${COMMON_OPTS} --info=progress2 --checksum"
alias           rsync-move="rsync ${COMMON_PARAMS} ${COMMON_OPTS} --info=progress2 --remove-source-files"
alias         rsync-update="rsync ${COMMON_PARAMS} ${COMMON_OPTS} --info=progress2 -u"
alias    rsync-synchronize="rsync ${COMMON_PARAMS} ${COMMON_OPTS} --info=progress2 -uXx --delete"
alias rsync-synchronize-cs="rsync ${COMMON_PARAMS} ${COMMON_OPTS} --info=progress2 -uXx --delete --checksum"

# alias           rsync-diff="rsync --dry-run -i --delete ${COMMON_PARAMS} -HhrltD"
# alias      rsync-diff-perm="rsync --dry-run -i --delete ${COMMON_PARAMS} ${COMMON_OPTS} -Xx"
# alias        rsync-diff-cs="rsync --dry-run -i --delete ${COMMON_PARAMS} ${COMMON_OPTS} -Xx --checksum"

alias     rsync-sudo-copy="sudo -E -s rsync ${COMMON_PARAMS} ${COMMON_OPTS} --info=progress2 -e 'ssh -l $USER'"
alias     rsync-sudo-sync="sudo -E -s rsync ${COMMON_PARAMS} ${COMMON_OPTS} --info=progress2 -e 'ssh -l $USER' -uXx --delete"
alias   rsync-sudo-update="sudo -E -s rsync ${COMMON_PARAMS} ${COMMON_OPTS} --info=progress2 -e 'ssh -l $USER' -u"

unset COMMON_PARAMS
unset COMMON_OPTS
