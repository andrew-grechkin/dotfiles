alias               cpv='rsync -Pa     --sparse'
alias        rsync-copy='rsync -ha     --sparse --info=progress2'
alias        rsync-move='rsync -ha     --sparse --info=progress2 --remove-source-files'
alias      rsync-update='rsync -hau    --sparse --info=progress2'
alias rsync-synchronize='rsync -hauHXx --sparse --info=progress2 --delete'

alias    rsync-copy-dep='rsync -ha     --progress --exclude '@eaDir''
