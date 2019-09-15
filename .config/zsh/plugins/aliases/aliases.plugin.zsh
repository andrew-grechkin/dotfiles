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
alias -g NUL="> /dev/null 2>&1"
alias -g P="2>&1| pygmentize -l pytb"

alias dud='du -d 1 -h'
alias duf='du -sh *'
#alias fd='find . -type d -iname'
#alias ff='find . -type f -iname'

# => file operations --------------------------------------------------------------------------------------------- {{{1

alias rm='rm -i'
alias cp='cp -i --reflink=auto --sparse=always'
alias mv='mv -i'

# => devel ------------------------------------------------------------------------------------------------------- {{{1

alias cmake-msys='cmake -G"MSYS Makefiles"'
alias gcc-all-defines='gcc -dM -E - < /dev/null | sort'

# => journal ----------------------------------------------------------------------------------------------------- {{{1

alias j='journalctl -b'
alias j-e='journalctl -b -p 4'
alias j-t='journalctl -fb'
alias j-rotate='sudo journalctl --rotate; sudo journalctl --vacuum-size=1'

# => yum --------------------------------------------------------------------------------------------------------- {{{1

alias yumdt='sudo yum group install "Development Tools"'

# => zsh --------------------------------------------------------------------------------------------------------- {{{1

alias fix-compaudit='compaudit | xargs chmod go-w'

# => go ---------------------------------------------------------------------------------------------------------- {{{1

alias gotest='go test -v -count 1 -failfast .'

# => vpn connections --------------------------------------------------------------------------------------------- {{{1

alias vpn-booking='sudo openvpn ~/.config/openvpn/booking.com.ovpn'
alias vpn-home='sudo openvpn ~/.config/openvpn/home.lan.ovpn'

# => python ------------------------------------------------------------------------------------------------------ {{{1

alias pip-ensure='python -m ensurepip --default-pip'
alias pip-upgrade='pip freeze | pip install --upgrade -r /dev/stdin'

# => opkg -------------------------------------------------------------------------------------------------------- {{{1

if [[ -x "/opt/bin/opkg" ]]; then
	alias -g apt=opkg
fi

# => pacman ------------------------------------------------------------------------------------------------------ {{{1

alias arch-list-altered-files='sudo pacman -Qkkq'
alias mirrors-update='sudo reflector --country Netherlands --latest 8 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist'

# => flibusta library -------------------------------------------------------------------------------------------- {{{1

alias library-generate='fb2index_1.0.0_linux_amd64 -http "0.0.0.0:55555" -db $HOME/.cache/fb2.Flibusta.Net.db -r /volume1/doc/lib/fb2.Flibusta.Net'
alias library-run='fb2index_1.0.0_linux_amd64 -http "0.0.0.0:55555" -db $HOME/.cache/fb2.Flibusta.Net.db'

# => misc -------------------------------------------------------------------------------------------------------- {{{1

alias se='SUDO_EDITOR=vim sudoedit'
alias fix-agent='eval $(tmux showenv -s SSH_AUTH_SOCK)'
alias dd='dd oflag=sync status=progress'
alias :q='exit'
