compiler perl
setlocal expandtab smarttab shiftwidth=4 softtabstop=4 tabstop=4
setlocal foldmethod=syntax

setlocal path+=**,/usr/lib/perl5/**,/usr/share/perl5/**
setlocal suffixesadd=.pl,.pm,.t

"perl include search works really slow, disable it
"setlocal include=^\\s*\\<\\(use\\\|require\\)\\>\\s\\+
"setlocal define=^\\s*\\<\\(sub\\\|has\\\|my\\\|our\\\|state\\\|package\\)\\>
setlocal include=
setlocal define=

setlocal wildignore+=*\\webservice\\*
setlocal formatprg=perltidy
setlocal iskeyword+=$,@,%

" Use old verion of syntax highlight regexp which look like working much faster (to check use syntime on -> syntime report)
" setlocal regexpengine=1

setlocal dictionary+=~/.local/share/vim-dict/perl
setlocal complete+=k

setlocal keywordprg=:Man
command! -nargs=1 Perldoc1 new
	\| :execute ":r !perl-doc '<args>'"
	\| :Man!
command! -nargs=+ Perldoc new
	\| :execute ':r !perldoc <args>'
	\| :Man!

"nnoremap <silent> <buffer> tt         :%!perltidy -q<CR>
vnoremap <silent> <buffer> tt         :!perltidy -q<CR>
nnoremap <silent> <buffer> K          :Perldoc1 <C-R>=expand("<cword>")<CR><CR>gg
vnoremap <silent> <buffer> K          y:Perldoc1 <C-R>=escape(@",'/\')<CR><CR>gg
nnoremap <silent> <buffer> <leader>ct :!ctags -R .<CR>
nnoremap <silent> <buffer> gz         :!zeal "perl:<cword>"&<CR><CR>
vnoremap <silent> <buffer> gz         y:!zeal "perl:<C-R>=escape(@",'/\')<CR>"&<CR>

let b:man_default_sections = '3,2'
set tags+=~/.local/share/vim-dict/perl.ctags
