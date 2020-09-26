# vim: syntax=zsh foldmethod=marker
# Based on https://github.com/robbyrussell/oh-my-zsh

# => ls ---------------------------------------------------------------------------------------------------------- {{{1

alias l='ls -lFhv  --group-directories-first'                                 # long list, show type, human readable, group dirs
alias la='l -A'
alias le='la --sort=extension'
alias lt='la --sort=time'

alias lsblk='lsblk -o NAME,FSTYPE,LABEL,UUID,SIZE,FSUSE%,RO,TYPE,MOUNTPOINT'

# => head, less -------------------------------------------------------------------------------------------------- {{{1

alias -g S='| sort'
alias -g H='| head'
alias -g L="| less"
alias -g LL="2>&1 | less"

alias -g NE="2> /dev/null"
alias -g NUL="&>/dev/null"

alias dud=' du -d 1 -h'
alias duf=' du -sh *'
#alias fd='find . -type d -iname'
#alias ff='find . -type f -iname'

# => file operations --------------------------------------------------------------------------------------------- {{{1

alias rm='rm -i'
alias cp='cp -i --reflink=auto --sparse=always'
alias mv='mv -i'

# => devel ------------------------------------------------------------------------------------------------------- {{{1

alias cmake-msys=' cmake -G"MSYS Makefiles"'
alias gcc-all-defines=' gcc -dM -E - < /dev/null | sort'

# => gpg --------------------------------------------------------------------------------------------------------- {{{1

alias gpg-edit-card='       gpg --edit-card'
alias gpg-edit='            gpg --expert --edit-key andrew.grechkin'
alias gpg-export-public='   gpg --export --armor andrew.grechkin'
alias gpg-list-public='     gpg --list-keys'
alias gpg-list-secret='     gpg --list-secret-keys'
alias gpg-list-signatures=' gpg --list-signatures'
alias gpg-refresh='         gpg --refresh-keys --verbose'

# => journal ----------------------------------------------------------------------------------------------------- {{{1

alias j-rotate=' sudo journalctl --rotate; sudo journalctl --vacuum-size=1'
alias        j=' sudo journalctl -fb --no-tail --since "1 week ago"      | fzf-journal'
alias      jte=' sudo journalctl -fb --no-tail --since "1 week ago" -p 4 | fzf-journal'

# => yum --------------------------------------------------------------------------------------------------------- {{{1

alias yumdt=' sudo yum group install "Development Tools"'

# => zsh --------------------------------------------------------------------------------------------------------- {{{1

alias fix-compaudit=' compaudit | xargs chmod go-w'

# => go ---------------------------------------------------------------------------------------------------------- {{{1

alias gotest=' go test -v -count 1 -failfast .'

# => opkg -------------------------------------------------------------------------------------------------------- {{{1

if [[ -x "/opt/bin/opkg" ]]; then
	alias -g apt=opkg
fi

# => pacman ------------------------------------------------------------------------------------------------------ {{{1

alias arch-list-altered-files=' sudo pacman -Qkkq'
alias arch-remove-orphans='     sudo pacman -Rns $(pacman -Qtdq)'
alias mirrors-update=' sudo reflector --country Netherlands --latest 8 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist'

# => misc -------------------------------------------------------------------------------------------------------- {{{1

alias se='SUDO_EDITOR=vim sudoedit'
alias fix-agent=' eval $(tmux showenv -s SSH_AUTH_SOCK)'
alias dd='dd oflag=sync status=progress'
alias :q=' exit'
alias :qa=' exit'

# => flibusta library -------------------------------------------------------------------------------------------- {{{1

alias library-generate=' fb2index_1.0.0_linux_amd64 -http "0.0.0.0:55555" -db $HOME/.cache/fb2.Flibusta.Net.db -r /volume1/doc/lib/fb2.Flibusta.Net'
alias library-run='      fb2index_1.0.0_linux_amd64 -http "0.0.0.0:55555" -db $HOME/.cache/fb2.Flibusta.Net.db'

# => media ------------------------------------------------------------------------------------------------------- {{{1

alias grab-cd='        abcde -xk -1 -o flac                   -a default,cue'
alias grab-cd-tracks=' abcde -xk    -o flac,ogg:"--quality=5" -a default,cue'

# => kubectl ----------------------------------------------------------------------------------------------------- {{{1

alias k='kubectl'
alias kga=' kubectl get all'
alias kaf=' kubectl apply -f'

# => diff/patch -------------------------------------------------------------------------------------------------- {{{1

alias diffdirs='diff -wBNuar'
