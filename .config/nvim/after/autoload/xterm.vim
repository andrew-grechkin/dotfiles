function! xterm#begin_paste()
	set pastetoggle=<Esc>[201~
	set paste
	return ''
endfunction

" Sends default register to terminal TTY using OSC 52 escape sequence (not supported by all terminals yet)
function! xterm#yank_osc52()
	let buffer=system('base64 -w0', @0)
	let buffer=substitute(buffer, "\n$", '', '')
	let buffer='\e]52;c;'.buffer.'\x07'
	silent exec '!echo -ne '.shellescape(buffer).' > '.shellescape('/dev/pts/0')
endfunction
