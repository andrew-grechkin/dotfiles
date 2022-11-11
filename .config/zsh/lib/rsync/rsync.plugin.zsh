alias               cpr='rsync -PHah    --sparse --exclude "@eaDir" --exclude "#recycle"'
alias               mvr='rsync -PHah    --sparse --exclude "@eaDir" --exclude "#recycle" --remove-source-files'
alias               upr='rsync -PHahu   --sparse --exclude "@eaDir" --exclude "#recycle"'

alias        rsync-copy='rsync -Hah     --sparse --info=progress2'
alias        rsync-move='rsync -Hah     --sparse --info=progress2 --remove-source-files'
alias      rsync-update='rsync -Hahu    --sparse --info=progress2'
alias rsync-synchronize='rsync -HahuAXx --sparse --info=progress2 --delete'
