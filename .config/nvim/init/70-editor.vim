scriptencoding=utf-8

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

" => Copy & paste ------------------------------------------------------------------------------------------------ {{{1

set clipboard=unnamedplus,unnamed                                              " Copy into system clipboard (*, +) registers

"vnoremap <C-c>                         "*y :let @+=@*<CR>
"vmap <C-c>                             y
"vmap <C-x>                             c<ESC>
"vmap <C-v>                             "0c<ESC>p
"imap <C-v>                             <C-r><C-o>+
