scriptencoding=utf-8

" => Keys remap -------------------------------------------------------------------------------------------------- {{{1

let mapleader = "\<Space>"                                                     " Map leader key
"silent! nnoremap ,,                    rё

" Open the current file in the default program
        nmap     <leader>x             :!xdg-open %<cr><cr>

" Easy insertion of a trailing ; or , from insert mode
		imap     ;;                    <Esc>A;<Esc>
		imap     ,,                    <Esc>A,<Esc>

" When text is wrapped, move by terminal rows, not lines, unless a count is provided
noremap <silent> <expr> j              (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k              (v:count == 0 ? 'gk' : 'k')

" Select all
silent! nnoremap <C-a>                 gg<S-v>G

":noremap <F12> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Fast split navigation
silent! nnoremap <leader>'             :belowright vsplit<CR>
silent! nnoremap <leader>"             :belowright split<CR>
silent! tnoremap <leader>'             :belowright vsplit<CR>
silent! tnoremap <leader>"             :belowright split<CR>

silent! tnoremap <leader><Esc>         <C-\><C-N>
silent! tnoremap <A-h>                 <C-\><C-N><C-w><Left>
silent! tnoremap <A-j>                 <C-\><C-N><C-w><Down>
silent! tnoremap <A-k>                 <C-\><C-N><C-w><Up>
silent! tnoremap <A-l>                 <C-\><C-N><C-w><Right>
" silent! tnoremap <C-h>                 <C-\><C-N><C-w><Left>
" silent! tnoremap <C-j>                 <C-\><C-N><C-w><Down>
" silent! tnoremap <C-k>                 <C-\><C-N><C-w><Up>
" silent! tnoremap <C-l>                 <C-\><C-N><C-w><Right>
" 		inoremap <A-h>                 <C-\><C-N><C-w><Left>
" 		inoremap <A-j>                 <C-\><C-N><C-w><Down>
" 		inoremap <A-k>                 <C-\><C-N><C-w><Up>
" 		inoremap <A-l>                 <C-\><C-N><C-w><Right>
" 		noremap  <A-h>                 <C-w><Left>
" 		noremap  <A-j>                 <C-w><Down>
" 		noremap  <A-k>                 <C-w><Up>
" 		noremap  <A-l>                 <C-w><Right>
		nnoremap <silent> <A-h>        :TmuxNavigateLeft<CR>
		nnoremap <silent> <A-j>        :TmuxNavigateDown<CR>
		nnoremap <silent> <A-k>        :TmuxNavigateUp<CR>
		nnoremap <silent> <A-l>        :TmuxNavigateRight<CR>
		nnoremap <silent> <A-\>        :TmuxNavigatePrevious<CR>
		inoremap <silent> <A-h>        :TmuxNavigateLeft<CR>
		inoremap <silent> <A-j>        :TmuxNavigateDown<CR>
		inoremap <silent> <A-k>        :TmuxNavigateUp<CR>
		inoremap <silent> <A-l>        :TmuxNavigateRight<CR>

" fast buffers
		nnoremap gh                    :bprevious<CR>
		nnoremap gl                    :bnext<CR>
		nnoremap <leader>b0            :blast<CR>
		nnoremap <leader>b1            :bfirst<CR>
		nnoremap <leader>b2            :b2<CR>

" fast tabs
		nnoremap <leader><leader>t     :tab split<CR>
		nnoremap <leader>h             :tabfirst<CR>
		nnoremap <leader>j             :tabprevious<CR>
		nnoremap <leader>k             :tabnext<CR>
		nnoremap <leader>l             :tablast<CR>
		nnoremap <leader>0             :tablast<CR>
		nnoremap <leader>1             :tabfirst<CR>
		nnoremap <leader>2             :tabnext 2<CR>
		nnoremap <leader>3             :tabnext 3<CR>
		nnoremap <leader>4             :tabnext 4<CR>
		nnoremap <leader>5             :tabnext 5<CR>
		nnoremap <leader>6             :tabnext 6<CR>
		nnoremap <leader>7             :tabnext 7<CR>
		nnoremap <leader>8             :tabnext 8<CR>
		nnoremap <leader>9             :tabnext 9<CR>

		nnoremap <C-PageDown>          :tabnext<CR>
		nnoremap <C-PageUp>            :tabprevious<CR>

" Yank without jank: http://ddrscott.github.io/blog/2016/yank-without-jank
		vnoremap  y                    myy`y
		vnoremap  Y                    myY`y

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

" => Mouse settings ---------------------------------------------------------------------------------------------- {{{1

if has('mouse')
	set mouse=a
"	noremap <ScrollWheelUp>            <C-Y>
"	noremap <ScrollWheelDown>          <C-E>
	noremap <S-ScrollWheelUp>          <C-U>
	noremap <S-ScrollWheelDown>        <C-D>
endif
