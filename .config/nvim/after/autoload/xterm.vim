" Sends default register to terminal TTY using OSC 52 escape sequence (not supported by all terminals yet)
function! xterm#yank_osc52()
	let buffer=system('base64 -w0', @0)
	let buffer='\e]52;c;'.buffer.'\x07'
	silent exec '!echo -ne '.shellescape(buffer).' > '.shellescape($TTY)
endfunction
