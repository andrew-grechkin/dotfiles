# vim: filetype=sh foldmethod=marker

if tput setaf 1 &> /dev/null; then
	tput sgr0

	c_blink=$(tput blink)
	c_bold=$(tput bold)
	c_normal=$(tput sgr0)
	c_reverse=$(tput smso)
	c_underline=$(tput smul)

	fg_black=$(tput setaf 0)
	fg_maroon=$(tput setaf 1)
	fg_green=$(tput setaf 2)
	fg_olive=$(tput setaf 3)
	fg_navy=$(tput setaf 4)
	fg_purple=$(tput setaf 5)
	fg_teal=$(tput setaf 6)
	fg_silver=$(tput setaf 7)
	fg_gray=$(tput setaf 8)
	fg_red=$(tput setaf 9)
	fg_lime=$(tput setaf 10)
	fg_yellow=$(tput setaf 11)
	fg_blue=$(tput setaf 12)
	fg_magenta=$(tput setaf 13)
	fg_aqua=$(tput setaf 14)
	fg_white=$(tput setaf 15)

	bg_black=$(tput setab 0)
	bg_maroon=$(tput setab 1)
	bg_green=$(tput setab 2)
	bg_olive=$(tput setab 3)
	bg_navy=$(tput setab 4)
	bg_purple=$(tput setab 5)
	bg_teal=$(tput setab 6)
	bg_silver=$(tput setab 7)
	bg_gray=$(tput setab 8)
	bg_red=$(tput setab 9)
	bg_lime=$(tput setab 10)
	bg_yellow=$(tput setab 11)
	bg_blue=$(tput setab 12)
	bg_magenta=$(tput setab 13)
	bg_aqua=$(tput setab 14)
	bg_white=$(tput setab 15)
else
	c_blink='\033[0;5m'
	c_bold='\033[0;1m'
	c_normal='\033[m'
	c_reverse='\033[0;7m'
	c_underline='\033[0;4m'

	fg_black='\033[0;30m'
	fg_maroon='\033[0;31m'
	fg_green='\033[0;32m'
	fg_olive='\033[0;33m'
	fg_navy='\033[0;34m'
	fg_purple='\033[0;35m'
	fg_teal='\033[0;36m'
	fg_silver='\033[0;37m'
	fg_gray='\033[1;30m'
	fg_red='\033[1;31m'
	fg_lime='\033[1;32m'
	fg_yellow='\033[1;33m'
	fg_blue='\033[1;34m'
	fg_magenta='\033[1;35m'
	fg_aqua='\033[1;36m'
	fg_white='\033[1;37m'

	bg_black='\033[0;40m'
	bg_maroon='\033[0;41m'
	bg_green='\033[0;42m'
	bg_olive='\033[0;43m'
	bg_navy='\033[0;44m'
	bg_purple='\033[0;45m'
	bg_teal='\033[0;46m'
	bg_silver='\033[0;47m'
	bg_gray='\033[1;40m'
	bg_red='\033[1;41m'
	bg_lime='\033[1;42m'
	bg_yellow='\033[1;43m'
	bg_blue='\033[1;44m'
	bg_magenta='\033[1;45m'
	bg_aqua='\033[1;46m'
	bg_white='\033[1;47m'
fi
