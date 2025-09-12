# vim: foldmethod=marker
# Based on https://github.com/robbyrussell/oh-my-zsh

# => builtin ------------------------------------------------------------------------------------------------------ {{{1

alias help='run-help'
alias :q='exit'
alias :qa='exit'

# => apps --------------------------------------------------------------------------------------------------------- {{{1

alias dd='command dd oflag=sync conv=sparse,excl status=progress'
alias fm='vifm . .'
alias htop='htop -u "$USER"'
alias j='~/.config/just/justfile'
alias vi-tsv='vi -c "set filetype=csv"'

# => commands ----------------------------------------------------------------------------------------------------- {{{1

alias e='menu-environment'
alias lsblk='lsblk -o NAME,TYPE,FSTYPE,LABEL,UUID,SIZE,FSAVAIL,FSUSE%,RO,MOUNTPOINTS'
alias -g xa='xargs -rd\n'
alias this-path='export PATH="$PATH:$(pwd)"'

# => ls ----------------------------------------------------------------------------------------------------------- {{{1

if [[ -n "$(command -v eza)"  ]]; then
    alias l='eza -lbF --group --time-style=long-iso --group-directories-first'
    alias la='l -a --sort=name'
else
    # long list, show type, human readable, group dirs
    alias l='ls -lFhv --group-directories-first'
    alias la='l -A'
fi

alias le='la --sort=extension'
alias lt='la --sort=time'

# => cat, head, less ---------------------------------------------------------------------------------------------- {{{1

alias -g S='| sort'
alias -g H='| head'
alias -g L='| less'
alias -g LL='2>&1 | less'

# => file operations ---------------------------------------------------------------------------------------------- {{{1

alias cp='cp -i --reflink=auto --sparse=always'
alias mv='mv -i'
alias rm='rm -i'
alias dangling-symlinks='ls -v **/*(-@)'
alias dangling-symlinks-remove='rm -v **/*(-@)'
alias dir-remove-empty='find . -depth -type d -empty -delete'
alias take-ownership=' sudo chown "${USER}:$(id -ng)" -R -- *; sudo chmod -R u+rwX,g+rX -- *; fd -u -E "@eaDir" -t d -x chmod g+s'
alias file-hardlinks='find . -xdev -samefile'

# => git ---------------------------------------------------------------------------------------------------------- {{{1

alias     cdr=' cd $(git root)'
alias cd-root=' cd $(git root)'

# => devel -------------------------------------------------------------------------------------------------------- {{{1

alias gcc-all-defines=' gcc -dM -E - < /dev/null | sort'

# => journal ------------------------------------------------------------------------------------------------------ {{{1

alias j-rotate='sudo journalctl --rotate; sudo journalctl --vacuum-size=1'
alias       jt='sudo journalctl -fb --no-tail --since "1 week ago"      | fzf-journal'
alias      jte='sudo journalctl -fb --no-tail --since "1 week ago" -p 4 | fzf-journal'

# => perf --------------------------------------------------------------------------------------------------------- {{{1

alias perf-record='sudo perf record -g -a sleep 10'
alias perf-report='sudo perf report'

# => yum ---------------------------------------------------------------------------------------------------------- {{{1

alias yumdt='sudo yum group install "Development Tools"'
alias yum-add-repo='yum-config-manager --add-repo "http://yum-mirror/yum/personal_repos/agrechkin/\$releasever/\$basearch/RPMS"'

# => zsh ---------------------------------------------------------------------------------------------------------- {{{1

alias fix-compaudit='compaudit | xargs -r chmod go-w'

# => go ----------------------------------------------------------------------------------------------------------- {{{1

alias gotest='go test -v -count 1 -failfast .'

# => opkg --------------------------------------------------------------------------------------------------------- {{{1

if [[ -x "/opt/bin/opkg" ]]; then
    alias -g apt='opkg'
fi

# => mail --------------------------------------------------------------------------------------------------------- {{{1

alias mbsync='mbsync -c ~/.config/isync/mbsyncrc andrew-grechkin julia-grechkina'

# => misc --------------------------------------------------------------------------------------------------------- {{{1

alias ssh-agent-fix='eval $(tmux showenv -s SSH_AUTH_SOCK)'

# => flibusta library --------------------------------------------------------------------------------------------- {{{1

alias library-generate='fb2index_1.0.0_linux_amd64 -http "0.0.0.0:55555" -db "$HOME/.cache/fb2.Flibusta.Net.db" -r "/volume1/doc/lib/fb2.Flibusta.Net"'
alias      library-run='fb2index_1.0.0_linux_amd64 -http "0.0.0.0:55555" -db "$HOME/.cache/fb2.Flibusta.Net.db"'

# => media -------------------------------------------------------------------------------------------------------- {{{1

alias        grab-cd='abcde -xk -1 -o flac                   -a default,cue'
alias grab-cd-tracks='abcde -xk    -o flac,ogg:"--quality=5" -a default,cue'

# => diff/patch --------------------------------------------------------------------------------------------------- {{{1

alias dir-diff='diff -wBNuar'

# => flatpak ------------------------------------------------------------------------------------------------------ {{{1

alias flatpak-user-setup='flatpak remote-add --if-not-exists --user flathub "https://flathub.org/repo/flathub.flatpakrepo"'
alias flatpak-system-setup='sudo flatpak remote-add --if-not-exists flathub "https://flathub.org/repo/flathub.flatpakrepo"'
# alias flatpak-user-setup='sudo flatpak --system remote-delete flathub; flatpak remote-add --if-not-exists --user flathub "https://dl.flathub.org/repo/flathub.flatpakrepo"'

# => network ------------------------------------------------------------------------------------------------------ {{{1

alias wg-import='sudo nmcli connection import type wireguard file'

# => token -------------------------------------------------------------------------------------------------------- {{{1

alias export-token-gitlab='__etgf() { pass show "token/https/gitlab.com/${1:-$USER}" | export-var GITLAB_TOKEN; }; __etgf'
alias export-bearer-tf='__ebtf() { pass show "token/https/app.terraform.io/${1:-$USER}" | export-var TF_BEARER; }; __ebtf'
