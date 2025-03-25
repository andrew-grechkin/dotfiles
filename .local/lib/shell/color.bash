# vim: filetype=sh foldmethod=marker

# shellcheck disable=SC2034

# cache="${XDG_STATE_HOME:-$HOME/.local/state}/cache-colors@${HOSTNAME}.bash"

# if [[ -r "$cache" ]]; then
# 	# shellcheck source=/dev/null
# 	source "$cache"
# else
typeset -Ag FX FG BG

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
FG=(
	[black]='\033[30m'  [gray]='\033[90m'
	[maroon]='\033[31m' [red]='\033[91m'
	[green]='\033[32m'  [lime]='\033[92m'
	[olive]='\033[33m'  [yellow]='\033[93m'
	[navy]='\033[34m'   [blue]='\033[94m'
	[purple]='\033[35m' [magenta]='\033[95m'
	[teal]='\033[36m'   [cyan]='\033[96m'     [aqua]='\033[96m'
	[silver]='\033[37m' [white]='\033[97m'
)
BG=(
	[black]='\033[40m'  [gray]='\033[100m'
	[maroon]='\033[41m' [red]='\033[101m'
	[green]='\033[42m'  [lime]='\033[102m'
	[olive]='\033[43m'  [yellow]='\033[103m'
	[navy]='\033[44m'   [blue]='\033[104m'
	[purple]='\033[45m' [magenta]='\033[105m'
	[teal]='\033[46m'   [cyan]='\033[106m'    [aqua]='\033[106m'
	[silver]='\033[47m' [white]='\033[107m'
)

# use hardcoded sequences for now, not sure how portable is this
# if tput sgr0 &>/dev/null; then
# 	FX[reset]="'$(tput sgr0)'"   FX[normal]="'$(tput sgr0)'"
# 	FX[bold]="$(tput bold)"
# 	FX[underline]="$(tput smul)"
# 	FX[blink]="$(tput blink)"
# 	FX[reverse]="$(tput smso)"

# 	FG[black]="$(tput setaf 0)"  FG[gray]="$(tput setaf 8)"
# 	FG[maroon]="$(tput setaf 1)" FG[red]="$(tput setaf 9)"
# 	FG[green]="$(tput setaf 2)"  FG[lime]="$(tput setaf 10)"
# 	FG[olive]="$(tput setaf 3)"  FG[yellow]="$(tput setaf 11)"
# 	FG[navy]="$(tput setaf 4)"   FG[blue]="$(tput setaf 12)"
# 	FG[purple]="$(tput setaf 5)" FG[magenta]="$(tput setaf 13)"
# 	FG[teal]="$(tput setaf 6)"   FG[cyan]="$(tput setaf 14)"    FG[aqua]="$(tput setaf 14)"
# 	FG[silver]="$(tput setaf 7)" FG[white]="$(tput setaf 15)"

# 	BG[black]="$(tput setab 0)"  BG[gray]="$(tput setab 8)"
# 	BG[maroon]="$(tput setab 1)" BG[red]="$(tput setab 9)"
# 	BG[green]="$(tput setab 2)"  BG[lime]="$(tput setab 10)"
# 	BG[olive]="$(tput setab 3)"  BG[yellow]="$(tput setab 11)"
# 	BG[navy]="$(tput setab 4)"   BG[blue]="$(tput setab 12)"
# 	BG[purple]="$(tput setab 5)" BG[magenta]="$(tput setab 13)"
# 	BG[teal]="$(tput setab 6)"   BG[cyan]="$(tput setab 14)"    BG[aqua]="$(tput setab 14)"
# 	BG[silver]="$(tput setab 7)" BG[white]="$(tput setab 15)"
# fi

# for color in {000..255}; do
# 	FG[$color]="\033[38;5;${color}m"
# 	BG[$color]="\033[48;5;${color}m"
# done

# echo "${FX[@]@A}"  > "$cache"
# echo "${FG[@]@A}" >> "$cache"
# echo "${BG[@]@A}" >> "$cache"
# fi
