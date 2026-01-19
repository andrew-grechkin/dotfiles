# Based on https://github.com/robbyrussell/oh-my-zsh

# A script to make using 256 colors in zsh less painful.
# P.C. Shyamshankar <sykora@lucentbeing.com>
# Copied from https://github.com/sykora/etc/blob/master/zsh/functions/spectrum/

function _term-spectrum() {
    ZSH_SPECTRUM_TEXT=${ZSH_SPECTRUM_TEXT:-Arma virumque cano Troiae qui primus ab oris}

    typeset -AHg FX FG BG

    FX=(
        reset     "%{[00m%}"
        bold      "%{[01m%}" no-bold      "%{[22m%}"
        italic    "%{[03m%}" no-italic    "%{[23m%}"
        underline "%{[04m%}" no-underline "%{[24m%}"
        blink     "%{[05m%}" no-blink     "%{[25m%}"
        reverse   "%{[07m%}" no-reverse   "%{[27m%}"
    )

    for color in {000..255}; do
        FG[$color]="%{[38;5;${color}m%}"
        BG[$color]="%{[48;5;${color}m%}"
    done
}

# Show all 256 colors with color number
function term-spectrum-ls() {
    _term-spectrum
    for code in {000..255}; do
        print -P -- "$code: %{$FG[$code]%}$ZSH_SPECTRUM_TEXT%{$reset_color%}"
    done
}

# Show all 256 colors where the background is set to specific color
function term-spectrum-bls() {
    _term-spectrum
    for code in {000..255}; do
        print -P -- "$code: %{$BG[$code]%}$ZSH_SPECTRUM_TEXT%{$reset_color%}"
    done
}

# => test terminal ------------------------------------------------------------------------------------------------ {{{1
# url: https://misc.flogisoft.com/bash/tip_colors_and_formatting

function term-test() {
    COLS=$(tput cols)
    awk -v cols="$COLS" 'BEGIN{
        p="/\\/\\/\\/\\/\\";
        s="";
        for (colnum = 0; colnum<cols; colnum+=10) {
            s=s p;
        }
        for (colnum = 0; colnum<cols; colnum++) {
            r = 255-(colnum*255/(cols-1));
            g = (colnum*510/(cols-1));
            b = (colnum*255/(cols-1));
            if (g>255) g = 510-g;
            printf "\033[48;2;%d;%d;%dm", r,g,b;
            printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
            printf "%s\033[0m", substr(s,colnum+1,1);
        }
        printf "\n";
    }'

    source "$HOME/.local/lib/shell/color.bash"

    echo -e "${FX[normal]}normal != =~ <=> //= ||= >= <="
    echo -e "${FX[italic]}italic != =~ <=> //= ||= >= <=${FX[no-italic]}"
    echo -e "${FX[bold]}bold   != =~ <=> //= ||= >= <="
    echo -e "${FX[italic]}italic != =~ <=> //= ||= >= <=${FX[no-italic]}"
    echo -e "${FX[dim]}dim    != =~ <=> //= ||= >= <="
    echo -e "${FX[italic]}italic != =~ <=> //= ||= >= <=${FX[no-italic]}"
    echo -en "${FX[normal]}"
    echo -e "${FX[underline]}underline != =~ <=> //= ||= >= <="
    echo -e "${FX[underline-off]}underline none"
    echo -e "${FX[underline-normal]}underline normal"
    echo -e "${FX[underline-double]}underline double"
    echo -e "${FX[underline-curly]}underline curly"
    echo -e "${FX[underline-dotted]}underline dotted"
    echo -e "${FX[underline-dashed]}underline dashed"
    echo -en "${FX[normal]}"
    echo -e "${FX[cross]}strikethrough${FX[no-cross]}"
    echo -e "\x1B[31mHello World\e[0m"
    echo -e "${FX[link]}https://gist.github.com/egmontkob/eb114294efbcd5adb1944c9f3cb5feda${FX[eos]}This is a link${FX[link]}${FX[eos]}"

    echo -e "${FX[overline]}overline${FX[no-overline]}"
    echo -e "${FX[circle]}encircled${FX[no-circle]}"
    echo -e "${FX[frame]}framed${FX[no-frame]}"

    echo -ne \\e\[1\;3\;4:3\;5\;53\;38\;2\;255\;127\;0\;58\;2\;0\;48\;255\;48\;2\;255\;0\;{0..255..8}mX \\e\[0m\\n
}
