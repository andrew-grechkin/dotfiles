# vim: foldmethod=marker
# Based on https://github.com/robbyrussell/oh-my-zsh

# => commands ----------------------------------------------------------------------------------------------------- {{{1

alias e='menu-environment'

# => ls ----------------------------------------------------------------------------------------------------------- {{{1

if [[ -n "$(command -v exa)"  ]]; then
	alias l='exa -lFh --group-directories-first'
	alias la='l -a --sort=name'
else
	alias l='ls -lFhv --group-directories-first' # long list, show type, human readable, group dirs
	alias la='l -A'
fi

alias le='la --sort=extension'
alias lt='la --sort=time'

alias lsblk='lsblk -o NAME,TYPE,FSTYPE,LABEL,UUID,SIZE,FSAVAIL,FSUSE%,RO,MOUNTPOINTS'

# => head, less --------------------------------------------------------------------------------------------------- {{{1

alias -g S='| sort'
alias -g H='| head'
alias -g L='| less'
alias -g LL='2>&1 | less'

alias -g NE='2>/dev/null'
alias -g NUL='&>/dev/null'

alias dud='du -hd 1'
alias duf='du -hs *'

# => file operations ---------------------------------------------------------------------------------------------- {{{1

alias cp='cp -i --reflink=auto --sparse=always'
alias mv='mv -i'
alias rm='rm -i'
alias dangling-symlinks='ls -v **/*(-@)'
alias dangling-symlinks-remove='rm -v **/*(-@)'
alias remove-empty-folders='find . -depth -type d -empty -delete'

# => git ---------------------------------------------------------------------------------------------------------- {{{1

alias     cdr=' cd $(git root)'
alias cd-root=' cd $(git root)'

# => devel -------------------------------------------------------------------------------------------------------- {{{1

alias gcc-all-defines=' gcc -dM -E - < /dev/null | sort'

# => gpg ---------------------------------------------------------------------------------------------------------- {{{1

alias       gpg-edit-card='gpg --edit-card'
alias            gpg-edit='gpg --expert --edit-key andrew.grechkin'
alias   gpg-export-public='gpg --export --armor andrew.grechkin'
alias     gpg-list-public='gpg --list-keys'
alias     gpg-list-secret='gpg --list-secret-keys'
alias gpg-list-signatures='gpg --list-signatures'
alias         gpg-refresh='gpg --refresh-keys --verbose'

# => journal ------------------------------------------------------------------------------------------------------ {{{1

alias j-rotate='sudo journalctl --rotate; sudo journalctl --vacuum-size=1'
alias        j='sudo journalctl -fb --no-tail --since "1 week ago"      | fzf-journal'
alias      jte='sudo journalctl -fb --no-tail --since "1 week ago" -p 4 | fzf-journal'

# => perf --------------------------------------------------------------------------------------------------------- {{{1

alias perf-record='sudo perf record -g -a sleep 10'
alias perf-report='sudo perf report'

# => yum ---------------------------------------------------------------------------------------------------------- {{{1

alias yumdt='sudo yum group install "Development Tools"'
alias yum-add-repo='yum-config-manager --add-repo "http://yum-mirror/yum/personal_repos/agrechkin/\$releasever/\$basearch/RPMS"'

# => zsh ---------------------------------------------------------------------------------------------------------- {{{1

alias fix-compaudit='compaudit | xargs chmod go-w'

# => go ----------------------------------------------------------------------------------------------------------- {{{1

alias gotest='go test -v -count 1 -failfast .'

# => opkg --------------------------------------------------------------------------------------------------------- {{{1

if [[ -x "/opt/bin/opkg" ]]; then
	alias -g apt='opkg'
fi

# => mail --------------------------------------------------------------------------------------------------------- {{{1

alias mbsync='mbsync -c ~/.config/isync/mbsyncrc andrew-grechkin julia-grechkina'

# => web ---------------------------------------------------------------------------------------------------------- {{{1

alias cget='command curl -LO -C - --'

# => misc --------------------------------------------------------------------------------------------------------- {{{1

alias -g xa='xargs -d "\n" -ri'
alias fm='vifm . .'
alias dd='command dd oflag=sync conv=sparse,excl status=progress'
alias :q='exit'
alias :qa='exit'

alias fix-agent='eval $(tmux showenv -s SSH_AUTH_SOCK)'

alias file-hardlinks='find . -xdev -samefile'

# => flibusta library --------------------------------------------------------------------------------------------- {{{1

alias library-generate='fb2index_1.0.0_linux_amd64 -http "0.0.0.0:55555" -db "$HOME/.cache/fb2.Flibusta.Net.db" -r "/volume1/doc/lib/fb2.Flibusta.Net"'
alias      library-run='fb2index_1.0.0_linux_amd64 -http "0.0.0.0:55555" -db "$HOME/.cache/fb2.Flibusta.Net.db"'

# => media -------------------------------------------------------------------------------------------------------- {{{1

alias        grab-cd='abcde -xk -1 -o flac                   -a default,cue'
alias grab-cd-tracks='abcde -xk    -o flac,ogg:"--quality=5" -a default,cue'

# => diff/patch --------------------------------------------------------------------------------------------------- {{{1

alias diffdirs='diff -wBNuar'

# => co stream ---------------------------------------------------------------------------------------------------- {{{1

alias run8='make -f ~/git/public/andrew-grechkin/centos-rpmbuild-docker/Makefile run8'
alias run9='make -f ~/git/public/andrew-grechkin/centos-rpmbuild-docker/Makefile run9'
alias build8-here='make -f ~/git/public/andrew-grechkin/centos-rpmbuild-docker/Makefile build8'
alias build9-here='make -f ~/git/public/andrew-grechkin/centos-rpmbuild-docker/Makefile build9'
