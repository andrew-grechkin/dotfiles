# vim: filetype=sh foldmethod=marker

# shellcheck disable=SC2034

# cache="${XDG_STATE_HOME:-$HOME/.local/state}/cache-colors@${HOSTNAME}.bash"

# if [[ -r "$cache" ]]; then
# 	# shellcheck source=/dev/null
# 	source "$cache"
# else
typeset -Ag FX FG BG

FX=(
    [reset]=$'\e[0m'     [normal]=$'\e[0m'
    [bold]=$'\e[1m'      [no-bold]=$'\e[21m'
    [dim]=$'\e[2m'       [no-dim]=$'\e[22m'
    [italic]=$'\e[3m'    [no-italic]=$'\e[23m'
    [underline]=$'\e[4m' [no-underline]=$'\e[24m'
    [blink]=$'\e[5m'     [no-blink]=$'\e[25m'
    [rapid]=$'\e[6m'     [no-rapid]=$'\e[25m'
    [reverse]=$'\e[7m'   [no-reverse]=$'\e[27m'
    [hide]=$'\e[8m'      [no-hide]=$'\e[28m'
    [cross]=$'\e[9m'     [no-cross]=$'\e[29m'
)
FG=(
    [black]=$'\e[30m'  [gray]=$'\e[90m'
    [maroon]=$'\e[31m' [red]=$'\e[91m'
    [green]=$'\e[32m'  [lime]=$'\e[92m'
    [olive]=$'\e[33m'  [yellow]=$'\e[93m'
    [navy]=$'\e[34m'   [blue]=$'\e[94m'
    [purple]=$'\e[35m' [magenta]=$'\e[95m'
    [teal]=$'\e[36m'   [cyan]=$'\e[96m'     [aqua]=$'\e[96m'
    [silver]=$'\e[37m' [white]=$'\e[97m'
)
BG=(
    [black]=$'\e[40m'  [gray]=$'\e[100m'
    [maroon]=$'\e[41m' [red]=$'\e[101m'
    [green]=$'\e[42m'  [lime]=$'\e[102m'
    [olive]=$'\e[43m'  [yellow]=$'\e[103m'
    [navy]=$'\e[44m'   [blue]=$'\e[104m'
    [purple]=$'\e[45m' [magenta]=$'\e[105m'
    [teal]=$'\e[46m'   [cyan]=$'\e[106m'    [aqua]=$'\e[106m'
    [silver]=$'\e[47m' [white]=$'\e[107m'
)

# reset sequence sgr0 for tmux-256color adds ^O at the end (^O is shift-in, switch to non-graphic character set)
# less prints ^O by default even when -R arg is passed and this makes output ugly
# this is most probably a bug in less itself because with -r flag less is not printing ^O symbols,
# but unfortunatelly -r flag is unusable because it breaks text formatting (colums)
# so there are 3 ways of solving this issue:
# * process all ouptut with `sed 's/\x0f//g'` before passing it to less
# * use terminal which doesn't add ^O as a part of reset sequence (xterm)
# * use hardcoded reset (might be not portable but who cares)

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
