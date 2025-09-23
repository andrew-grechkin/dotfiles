# vim: filetype=sh foldmethod=marker

# shellcheck disable=SC2034
#
# Code     Effect                       Note
# 0	       Reset / Normal               all attributes off
# 1        Bold or increased intensity
# 2        Faint (decreased intensity)
# 3        Italic
# 4        Underline
# 5        Slow Blink                   less than 150 per minute
# 6        Rapid Blink
# 7        reverse                      swap foreground and background colors
# 8        Conceal
# 9        Crossed-out                  Characters legible, but marked for deletion.
# 10       Primary(default) font
# 11–19    Alternate font               Select alternate font n-10
# 20       Fraktur                      hardly ever supported
# 21       Bold off
# 22       Normal color or intensity    Neither bold nor faint
# 23       Not italic, not Fraktur
# 24       Underline off                Not singly or doubly underlined
# 25       Blink off
# 27       Inverse off
# 28       Reveal                       conceal off
# 29       Not crossed out
# 30–37    Set foreground color
# 38       Set foreground color         Next arguments are 5;<n> or 2;<r>;<g>;<b>
# 39       Default foreground color	implementation defined (according to standard)
# 40–47    Set background color
# 48       Set background color         Next arguments are 5;<n> or 2;<r>;<g>;<b>
# 49       Default background color	implementation defined (according to standard)
# 51       Framed
# 52       Encircled
# 53       Overlined
# 54       Not framed or encircled
# 55       Not overlined
# 60       ideogram underline
# 61       ideogram double underline
# 62       ideogram overline
# 63       ideogram double overline
# 64       ideogram stress marking
# 65       ideogram attributes off      reset the effects of all of 60-64
# 90–97    bright foreground color
# 100–107  bright background color

# cache="${XDG_STATE_HOME:-$HOME/.local/state}/cache-colors@${HOSTNAME}.bash"

# if [[ -r "$cache" ]]; then
# 	# shellcheck source=/dev/null
# 	source "$cache"
# else
declare -Ag FX FG BG

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

    [overline]=$'\e[53m' [no-overline]=$'\e[55m'
    [frame]=$'\e[51m'    [no-frame]=$'\e[54m'
    [cirle]=$'\e[52m'    [no-cirle]=$'\e[54m'

    [underline-off]=$'\e[4:0m'    [ul-off]=$'\e[4:0m'
    [underline-normal]=$'\e[4:1m' [ul-normal]=$'\e[4:1m'
    [underline-double]=$'\e[4:2m' [ul-double]=$'\e[4:2m'
    [underline-curly]=$'\e[4:3m'  [ul-curly]=$'\e[4:3m'
    [underline-dotted]=$'\e[4:4m' [ul-dotted]=$'\e[4:4m'
    [underline-dashed]=$'\e[4:5m' [ul-dashed]=$'\e[4:5m'

    # https://gist.github.com/egmontkob/eb114294efbcd5adb1944c9f3cb5feda
    # "${FX[link]}http://example.com${FX[eos]}This is a link${FX[link]}${FX[eos]}"
    [link]=$'\e]8;;'           # OSC 8 ; params ; URI ST
    [eos]=$'\e\x5c'            # ST (string terminator) end of a string, for hyperlinks
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

function color() {
    local color_name="$1"
    shift

    if [[ -n "${FG[$color_name]:-}" ]]; then
        echo "${FG[$color_name]}$*${FX[reset]}"
    elif [[ -n "${FX[$color_name]:-}" ]]; then
        echo "${FX[$color_name]}$*${FX[reset]}"
    else
        echo "$@"
    fi
}

function color256() {
    local color_code="$1"
    shift

    echo -e "\e[38;5;${color_code}m$*${FX[reset]}"
}

function colorRGB() {
    local r="$1"
    local g="$2"
    local b="$3"
    shift 3

    echo -e "\e[38;2;${r};${g};${b}m$*${FX[reset]}"
}

# echo "${BG[@]@A}" >> "$cache"
# fi
