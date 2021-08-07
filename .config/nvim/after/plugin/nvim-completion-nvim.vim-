if !exists('g:loaded_completion') | finish | endif

augroup EnableCompletion
	autocmd!
	autocmd BufEnter * lua require('completion').on_attach()
	autocmd BufEnter * lua require('nvim-completion_dictionary').on_attach()
augroup END
" lua require 'nvim-completion_dictionary'.add_sources()

" possible value: 'UltiSnips', 'Neosnippet', 'vim-vsnip', 'snippets.nvim'
let g:completion_enable_snippet = 'UltiSnips'

let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy', 'all']
let g:completion_matching_smart_case    = 1
let g:completion_trigger_keyword_length = 2

augroup CompletionTriggerCharacter
    autocmd!
    autocmd BufEnter * let g:completion_trigger_character = ['.']
    autocmd BufEnter *.c,*.cpp let g:completion_trigger_character = ['.', '::']
    autocmd BufEnter *.pl,*.pm let g:completion_trigger_character = ['->', '::']
augroup end

let g:completion_chain_complete_list = {
	\ 'default': [
	\    {'complete_items': ['path', 'lsp', 'snippet', 'tags', 'dictionary']},
	\    {'mode': '<c-p>'},
	\    {'mode': '<c-n>'}
	\]
\}
" \    {'complete_items': ['buffers']},

" let g:completion_confirm_key = ""
" imap     <expr> <CR>    pumvisible()
	" \ ? complete_info()["selected"] != "-1"
		" \ ?  "\<Plug>(completion_confirm_completion)"
		" \ : "\<c-e>\<CR>"
	" \ :  "\<CR>"

" Use <Tab> and <S-Tab> to navigate through popup menu
" inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
imap     <Tab>   <Plug>(completion_smart_tab)
imap     <S-tab> <Plug>(completion_smart_s_tab)
