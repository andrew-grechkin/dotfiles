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

	echo -ne \\e\[1\;3\;4:3\;5\;53\;38\;2\;255\;127\;0\;58\;2\;0\;48\;255\;48\;2\;255\;0\;{0..255..8}mX \\e\[0m\\n

	echo -e "normal"
	echo -e "ligatures: != =~ <=> //= ||= >= <="
	echo -e "\e[1mbold\e[0m"
	echo -e "\e[3mitalic\e[0m"
	echo -e "\e[3m\e[1mbold italic\e[0m"
	echo -e "\e[4munderline\e[0m"
	echo -e "\e[4:0m underline none\e[0m"
	echo -e "\e[4:1m underline normal\e[0m"
	echo -e "\e[4:2m underline double\e[0m"
	echo -e "\e[4:3m underline curly\e[0m"
	echo -e "\e[4:4m underline dotted\e[0m"
	echo -e "\e[4:5m underline dashed\e[0m"
	echo -e "\e[9mstrikethrough\e[0m"
	echo -e "\e[31mHello World\e[0m"
	echo -e "\x1B[31mHello World\e[0m"
	echo -e '\e]8;;http://example.com\e\\This is a link\e]8;;\e\\\n'
}
