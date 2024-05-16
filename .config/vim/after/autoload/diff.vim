function! diff#toggle_ignore_whitespace()
	if &diffopt =~# 'iwhite'
		set diffopt-=iwhite
	else
		set diffopt+=iwhite
	endif
endfunction

function! diff#toggle_algorithm()
	if &diffopt =~# 'algorithm:myers'
		set diffopt-=algorithm:myers
		set diffopt+=algorithm:patience
	elseif &diffopt =~# 'algorithm:patience'
		set diffopt-=algorithm:patience
		set diffopt+=algorithm:minimal
	elseif &diffopt =~# 'algorithm:minimal'
		set diffopt-=algorithm:minimal
		set diffopt+=algorithm:histogram
	elseif &diffopt =~# 'algorithm:histogram'
		set diffopt-=algorithm:histogram
		set diffopt+=algorithm:myers
	else
		set diffopt+=algorithm:patience
	endif
endfunction
