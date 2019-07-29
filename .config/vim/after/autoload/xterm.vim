function! xterm#begin_paste()
	set pastetoggle=<Esc>[201~
	set paste
	return ''
endfunction
