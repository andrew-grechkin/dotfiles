" => Copy & paste ------------------------------------------------------------------------------------------------ {{{1

set clipboard=unnamedplus                                                      " Copy into system clipboard (*, +) registers

"vnoremap <C-c>                         "*y :let @+=@*<CR>
"vmap <C-c>                             y
"vmap <C-x>                             c<ESC>
"vmap <C-v>                             "0c<ESC>p
"imap <C-v>                             <C-r><C-o>+

" disable indent while inserting from buffer
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"
inoremap <special> <expr> <Esc>[200~ xterm#begin_paste()
