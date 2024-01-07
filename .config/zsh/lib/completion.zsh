# vim: filetype=zsh foldmethod=marker
# Based on https://github.com/robbyrussell/oh-my-zsh
# https://thevaluable.dev/zsh-completion-guide-examples/

zmodload -i zsh/complist

unsetopt FLOW_CONTROL
unsetopt LIST_BEEP
unsetopt MENU_COMPLETE                                                         # do not autoselect the first completion entry
setopt   ALWAYS_TO_END
setopt   AUTO_MENU                                                             # show completion menu on successive tab press
setopt   COMPLETE_IN_WORD
setopt   LIST_PACKED

zstyle ':completion:*:*:*:*:*'            menu select
# Rehash every completion
zstyle ':completion:*'                    rehash true
# Produce . and .. in completion
#zstyle ':completion:*'                    special-dirs true
zstyle ':completion:*'                    list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes'    command "ps -u $USER -o pid,user,comm -w -w"
# disable named-directories autocompletion
#zstyle ':completion:*:default'            complete-options true
#zstyle ':completion:*:cd:*'               tag-order local-directories directory-stack path-directories
# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion::complete:*'          use-cache 1
zstyle ':completion::complete:*'          cache-path $ZSH_CACHE_DIR
# Don't complete uninteresting users
zstyle ':completion:*:*:*:users'          ignored-patterns \
	adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
	clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
	gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
	ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
	named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
	operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
	rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
	usbmux uucp vcsa wwwrun xfs '_*'
# ... unless we really want to

# format completion
zstyle ':completion:*:descriptions'       format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'

# split into groups
zstyle ':completion:*:matches'            group 'yes'
zstyle ':completion:*'                    group-name ''


zstyle '*'                                single-ignored show

# => Case insensitive (all), partial-word and substring completion ------------------------------------------------ {{{1

if [[ -n $CASE_SENSITIVE ]]; then
	zstyle ':completion:*'                matcher-list 'r:|=*' 'l:|=* r:|=*'
else
	if [[ -n $HYPHEN_INSENSITIVE ]]; then
		zstyle ':completion:*'            matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
	else
		zstyle ':completion:*'            matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
	fi
fi

unset CASE_SENSITIVE HYPHEN_INSENSITIVE

# => Draw dots on completion -------------------------------------------------------------------------------------- {{{1

if [[ $COMPLETION_WAITING_DOTS = true ]]; then
	expand-or-complete-with-dots() {
		# toggle line-wrapping off and back on again
		[[ -n "$terminfo[rmam]" && -n "$terminfo[smam]" ]] && echoti rmam
		print -Pn "%{%F{red}......%f%}"
		[[ -n "$terminfo[rmam]" && -n "$terminfo[smam]" ]] && echoti smam

		zle expand-or-complete
		zle redisplay
	}
	zle -N expand-or-complete-with-dots
	bindkey "^I" expand-or-complete-with-dots
fi

# => enabling autocompletion of privileged environments in privileged commands ------------------------------------ {{{1

# This will let zsh completion scripts run commands with sudo privileges. You should not enable this if you use untrusted autocompletion scripts.
#zstyle ':completion::complete:*' gain-privileges 1

# => init completion ---------------------------------------------------------------------------------------------- {{{1

autoload -Uz compinit
compinit -d "$ZSH_COMPDUMP"
