alias               cpv='rsync -Pa      --sparse'
alias        rsync-copy='rsync -ha      --sparse --info=progress2'
alias        rsync-move='rsync -ha      --sparse --info=progress2 --remove-source-files'
alias      rsync-update='rsync -hau     --sparse --info=progress2'
alias rsync-synchronize='rsync -hauHAXx --sparse --info=progress2 --delete'

alias    rsync-copy-dep='rsync -PhaH    --exclude "@eaDir"'
alias    rsync-move-dep='rsync -PhaH    --exclude "@eaDir" --remove-source-files'
alias  rsync-update-dep='rsync -PhauH   --exclude "@eaDir"'
