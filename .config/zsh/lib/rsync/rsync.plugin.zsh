COMMON_PARAMS='--sparse --exclude="@eaDir" --exclude="#recycle" --exclude="#snapshot" --exclude=".Trash-*"'
COMMON_OPTS='-Hah'

alias               cpr="rsync-copy --info=progress2"

# alias           rsync-diff="rsync --dry-run -i --delete ${COMMON_PARAMS} -HhrltD"
# alias      rsync-diff-perm="rsync --dry-run -i --delete ${COMMON_PARAMS} ${COMMON_OPTS} -Xx"
# alias        rsync-diff-cs="rsync --dry-run -i --delete ${COMMON_PARAMS} ${COMMON_OPTS} -Xx --checksum"

alias     rsync-sudo-copy="sudo -E -s rsync ${COMMON_PARAMS} ${COMMON_OPTS} --info=progress2 -e 'ssh -l $USER'"
alias     rsync-sudo-sync="sudo -E -s rsync ${COMMON_PARAMS} ${COMMON_OPTS} --info=progress2 -e 'ssh -l $USER' -uXx --delete"
alias   rsync-sudo-update="sudo -E -s rsync ${COMMON_PARAMS} ${COMMON_OPTS} --info=progress2 -e 'ssh -l $USER' -u"

unset COMMON_PARAMS
unset COMMON_OPTS
