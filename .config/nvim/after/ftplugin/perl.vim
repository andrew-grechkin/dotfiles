compiler perl

setlocal foldmethod=syntax

setlocal iskeyword+=$,@,%
setlocal path=.,,./lib/**,./slib/**,~/.local/lib/perl5/**
if !empty($PERL_LOCAL_LIB_ROOT)
	setlocal path+=$PERL_LOCAL_LIB_ROOT/lib/perl5/**
end
setlocal path+=/usr/lib/perl5/**,/usr/share/perl5/**
setlocal suffixesadd=.pm
setlocal wildignore+=*\\webservice\\*

"perl include search works really slow, disable it
"setlocal include=^\\s*\\<\\(use\\\|require\\)\\>\\s\\+
"setlocal define=^\\s*\\<\\(sub\\\|has\\\|my\\\|our\\\|state\\\|package\\)\\>
setlocal include=
setlocal define=

" Use old verion of syntax highlight regexp which look like working much faster (to check use syntime on -> syntime report)
" setlocal regexpengine=1

setlocal complete+=k
setlocal dictionary+=~/.local/share/vim-dict/perl
setlocal tags+=~/.local/share/vim-dict/perl.ctags

" => -------------------------------------------------------------------------------------------------------------- {{{1

let b:man_default_sections = '3,2'

setlocal equalprg=perltidy\ -q
setlocal formatprg=perltidy\ -q
setlocal keywordprg=:Perldoc

command! -nargs=1 Perldoc :setlocal splitright
	\| :vnew
	\| :setlocal buftype=nofile bufhidden=hide noswapfile
	\| :execute ":r !doc-perldoc-wrapper '<args>'"
	\| :Man!
	\| :vertical resize 80
	\| :norm gg

nnoremap <silent> <buffer> gz         :!<C-R>=g:zeal_app<CR> "perl:<cword>"&<CR><CR>
vnoremap <silent> <buffer> gz        y:!<C-R>=g:zeal_app<CR> "perl:<C-R>=escape(@",'/\')<CR>"&<CR><CR>
""nnoremap <silent> <buffer> tt         :%!perltidy -q<CR>
" vnoremap <silent> <buffer> tt         :!perltidy -q<CR>
"nnoremap <silent> <buffer> K          :Perldoc1 <C-R>=expand("<cword>")<CR><CR>gg
"vnoremap <silent> <buffer> K         y:Perldoc1 <C-R>=escape(@",'/\')<CR><CR>gg
