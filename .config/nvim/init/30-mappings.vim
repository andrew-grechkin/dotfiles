scriptencoding=utf-8

" :nmap
" :imap
" :vmap

" => Mouse settings ---------------------------------------------------------------------------------------------- {{{1

if has('mouse')
	set mouse=a
"	noremap <ScrollWheelUp>            <C-Y>
"	noremap <ScrollWheelDown>          <C-E>
	nnoremap <S-ScrollWheelUp>         <C-U>
	nnoremap <S-ScrollWheelDown>       <C-D>
endif

" => Keys remap -------------------------------------------------------------------------------------------------- {{{1

let mapleader = "\<Space>"                                                     " Map leader key

" save register on paste over text
" vnoremap <silent> p p:let @+=@0<CR>:let @"=@0<CR>
" xnoremap p "_dP

" Easy insertion of a trailing ; or , from insert mode
" 		imap     ;;                    <Esc>A;<Esc>

" When text is wrapped, move by terminal rows, not lines, unless a count is provided
noremap <silent> <expr> j              (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k              (v:count == 0 ? 'gk' : 'k')

":noremap <F12> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

silent! tnoremap <leader><Esc>         <C-\><C-N>
silent! tnoremap <A-h>                 <C-\><C-N><C-w><Left>
silent! tnoremap <A-j>                 <C-\><C-N><C-w><Down>
silent! tnoremap <A-k>                 <C-\><C-N><C-w><Up>
silent! tnoremap <A-l>                 <C-\><C-N><C-w><Right>
" silent! tnoremap <C-h>                 <C-\><C-N><C-w><Left>
" silent! tnoremap <C-j>                 <C-\><C-N><C-w><Down>
" silent! tnoremap <C-k>                 <C-\><C-N><C-w><Up>
" silent! tnoremap <C-l>                 <C-\><C-N><C-w><Right>

" => Old/new ----------------------------------------------------------------------------------------------------- {{{1

if has('nvim-0.5')                                                         " Neovim with lua only
" use whichkey
else
" Open the current file in the default program
        nmap     <leader>x             :!xdg-open %<cr><cr>

" Fast split navigation
silent! nnoremap <leader>'             :belowright vsplit<CR>
silent! nnoremap <leader>"             :belowright split<CR>
silent! tnoremap <leader>'             :belowright vsplit<CR>
silent! tnoremap <leader>"             :belowright split<CR>

" Make Y behave like the other capitals (yank till the end of line)
		nnoremap  Y                    y$

" Black hole deletes
		nnoremap <leader>d             "_d
		vnoremap <leader>dd            "_dd

" Paste replace visual selection without copying it
		vnoremap <leader>P             "_dP

" < and > don't loose selection when changing indentation
		vnoremap <                     <gv
		vnoremap >                     >gv

" center after operations
		nnoremap n                     nzzzv
		nnoremap N                     Nzzzv
		nnoremap J                     mzJ`z

" Clear current search highlighting
		nnoremap <leader><leader>l     :nohlsearch<CR>

" Open terminal
		nnoremap <leader><leader>m     :belowright 10split term://zsh<CR>

		nnoremap <leader>.             :execute 'lcd' dir#git_root()<CR>
"		nnoremap <leader>.             :lcd %:p:h<CR>

" => Bookmarks --------------------------------------------------------------------------------------------------- {{{1

		nnoremap <leader><leader>v     :tabedit <C-R>=VIM_CONFIG_FILE<CR><CR>
		nnoremap <leader><leader>z     :tabedit ~/.zshenv<CR>

" Select all
silent! nnoremap <C-a>                 gg<S-v>G

" Yank without jank: http://ddrscott.github.io/blog/2016/yank-without-jank
		vnoremap  y                    myy`y
		vnoremap  Y                    myY`y

" fast buffers
		nnoremap gh                    :bprevious<CR>
		nnoremap gl                    :bnext<CR>
		nnoremap <leader>b0            :blast<CR>
		nnoremap <leader>b1            :bfirst<CR>

endif
