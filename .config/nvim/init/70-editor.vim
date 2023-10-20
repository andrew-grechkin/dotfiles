scriptencoding=utf-8

set splitright
set complete+=kspell                                                           " Complete from include files and from spell if enabled
set shortmess+=c
set completeopt=menuone,noinsert,noselect,preview

set foldcolumn=2
" set foldmethod=syntax

set list listchars=tab:↹\ ,trail:␣,extends:>,precedes:<,nbsp:+                 " Visual form of special characters
"set listchars+=eol:↵                                                          " Visible end of line

set showmatch matchpairs+=<:>,«:»

set whichwrap+=<,>,h,l

set display+=lastline                                                          " Prettier display of long lines of text

set virtualedit=block

" filetype plugin indent on

set breakindent
set colorcolumn=121                                                            " Break line on 120 characters
let &showbreak = '--->'                                                        " Pretty soft break character

set autoindent smartindent                                                     " Copy indent from the previous line

set noexpandtab smarttab shiftwidth=4 softtabstop=4 tabstop=4
set noshiftround

set formatoptions=tcqjl                                                        " More intuitive autoformatting

"set linebreak                                                                  " Soft word wrap

" => Copy & paste ------------------------------------------------------------------------------------------------- {{{1

set clipboard=unnamedplus,unnamed                                              " Copy into system clipboard (*, +) registers

"vnoremap <C-c>                         "*y :let @+=@*<CR>
"vmap <C-c>                             y
"vmap <C-x>                             c<ESC>
"vmap <C-v>                             "0c<ESC>p
"imap <C-v>                             <C-r><C-o>+

" => whole file text object --------------------------------------------------------------------------------------- {{{1

" There is no text object for the whole file by default, but it is possible to create them using omap. In this case, it would look something like this:
"
" onoremap f :<c-u>normal! mzggVG<cr>`z
"
" Here is a breakdown of how it works:
" onoremap f " make 'f' the text object name
" :<c-u> " use <c-u> to prevent vim from inserting visual selection marker at the beginning of the command automatically.
" normal! " use normal to make key presses ignoring any user mappings
" mzggVG<cr>`z " make a marker in register z, select the entire file in visual line mode and enter the normal command, and go back to the z marker
" Notes:
" Ctrl-u can be used in the command line mode to delete everything to the left of the cursor position. The reason why this is done is because if you enter the command line straight from visual mode, it will automatically insert '<,'> on the command line, and that isn't what we want. I would also suggest you use something other than f, because f is normally used to move to the next searched character on the line. For example, fi will go to the next i on the current line.
" Relevant help topics:
" :help omap-info
" :help :normal
" :help c_CTRL-U
" :help v_:
onoremap q :<C-u>normal! mzggVG<CR>`z
