# vim: filetype=sh foldmethod=marker

# shellcheck disable=SC2034,SC2028

typeset -Ag FX FG BG

# for color in {000..255}; do
# 	FG[$color]="\033[38;5;${color}m"
# 	BG[$color]="\033[48;5;${color}m"
# done

# use hardcoded sequences for now, not sure how portable is this
# if tput sgr0 &>/dev/null; then
if ((0)); then
	FX=(
		[reset]='\033[0m'     [normal]='\033[0m'
		[bold]='\033[1m'      [no-bold]='\033[21m'
		[light]='\033[2m'     [no-light]='\033[22m'
		[italic]='\033[3m'    [no-italic]='\033[23m'
		[underline]='\033[4m' [no-underline]='\033[24m'
		[blink]='\033[5m'     [no-blink]='\033[25m'
		[rapid]='\033[6m'     [no-rapid]='\033[25m'
		[reverse]='\033[7m'   [no-reverse]='\033[27m'
		[hide]='\033[8m'      [no-hide]='\033[28m'
		[cross]='\033[9m'     [no-cross]='\033[29m'
	)
	# c_blink="$(tput blink)"
	# c_bold="$(tput bold)"
	# c_normal="'$(tput sgr0)'"
	# c_reverse="$(tput smso)"
	# c_reset="'$(tput sgr0)'"
	# c_underline="$(tput smul)"
	FG[black]="$(tput setaf 0)"
	FG[maroon]="$(tput setaf 1)"
	FG[green]="$(tput setaf 2)"
	FG[olive]="$(tput setaf 3)"
	FG[navy]="$(tput setaf 4)"
	FG[purple]="$(tput setaf 5)"
	FG[teal]="$(tput setaf 6)"
	FG[silver]="$(tput setaf 7)"
	FG[gray]="$(tput setaf 8)"
	FG[red]="$(tput setaf 9)"
	FG[lime]="$(tput setaf 10)"
	FG[yellow]="$(tput setaf 11)"
	FG[blue]="$(tput setaf 12)"
	FG[magenta]="$(tput setaf 13)"
	FG[cyan]="$(tput setaf 14)"    FG[aqua]="$(tput setaf 14)"
	FG[white]="$(tput setaf 15)"

	BG[black]="$(tput setab 0)"
	BG[maroon]="$(tput setab 1)"
	BG[green]="$(tput setab 2)"
	BG[olive]="$(tput setab 3)"
	BG[navy]="$(tput setab 4)"
	BG[purple]="$(tput setab 5)"
	BG[teal]="$(tput setab 6)"
	BG[silver]="$(tput setab 7)"
	BG[gray]="$(tput setab 8)"
	BG[red]="$(tput setab 9)"
	BG[lime]="$(tput setab 10)"
	BG[yellow]="$(tput setab 11)"
	BG[blue]="$(tput setab 12)"
	BG[magenta]="$(tput setab 13)"
	BG[cyan]="$(tput setab 14)"    BG[aqua]="$(tput setab 14)"
	BG[white]="$(tput setab 15)"
else
	FX=(
		[reset]='\033[0m'     [normal]='\033[0m'
		[bold]='\033[1m'      [no-bold]='\033[21m'
		[dim]='\033[2m'       [no-dim]='\033[22m'
		[italic]='\033[3m'    [no-italic]='\033[23m'
		[underline]='\033[4m' [no-underline]='\033[24m'
		[blink]='\033[5m'     [no-blink]='\033[25m'
		[rapid]='\033[6m'     [no-rapid]='\033[25m'
		[reverse]='\033[7m'   [no-reverse]='\033[27m'
		[hide]='\033[8m'      [no-hide]='\033[28m'
		[cross]='\033[9m'     [no-cross]='\033[29m'
	)

	FG[black]='\033[30m'
	FG[maroon]='\033[31m'
	FG[green]='\033[32m'
	FG[olive]='\033[33m'
	FG[navy]='\033[34m'
	FG[purple]='\033[35m'
	FG[teal]='\033[36m'
	FG[silver]='\033[37m'
	FG[gray]='\033[90m'
	FG[red]='\033[91m'
	FG[lime]='\033[92m'
	FG[yellow]='\033[93m'
	FG[blue]='\033[94m'
	FG[magenta]='\033[95m'
	FG[cyan]='\033[96m'    FG[aqua]='\033[96m'
	FG[white]='\033[97m'

	BG[black]='\033[40m'
	BG[maroon]='\033[41m'
	BG[green]='\033[42m'
	BG[olive]='\033[43m'
	BG[navy]='\033[44m'
	BG[purple]='\033[45m'
	BG[teal]='\033[46m'
	BG[silver]='\033[47m'
	BG[gray]='\033[100m'
	BG[red]='\033[101m'
	BG[lime]='\033[102m'
	BG[yellow]='\033[103m'
	BG[blue]='\033[104m'
	BG[magenta]='\033[105m'
	BG[cyan]='\033[106m'   BG[aqua]='\033[106m'
	BG[white]='\033[107m'
fi
