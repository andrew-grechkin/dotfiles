" => airline.vim ------------------------------------------------------------------------------------------------- {{{1

let g:airline_highlighting_cache = 1

" => ale.vim ----------------------------------------------------------------------------------------------------- {{{1

let g:ale_completion_enabled       = 0

""" necessary for UltiSnips
let g:ale_lint_on_enter            = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_insert_leave     = 0
let g:ale_lint_on_text_changed     = 0

" => hexokinase.vim ---------------------------------------------------------------------------------------------- {{{1

let g:Hexokinase_highlighters = [ 'backgroundfull' ]

" => man.vim ----------------------------------------------------------------------------------------------------- {{{1

let g:man_hardwrap = 1

" => perl.vim ---------------------------------------------------------------------------------------------------- {{{1

" man: ft-perl-syntax
let perl_fold                  = 1
let perl_include_pod           = 0
let perl_no_extended_vars      = 1
let perl_no_scope_in_variables = 1
let perl_nofold_packages       = 1

" => vim-grepper ------------------------------------------------------------------------------------------------- {{{1

let g:grepper = {}

" => python.vim -------------------------------------------------------------------------------------------------- {{{1

let g:loaded_python_provider = 0
let g:python_host_prog  = 'python'
let g:python3_host_prog = 'python'

" => signify.vim ------------------------------------------------------------------------------------------------- {{{1

let g:signify_vcs_cmds = {
	\ 'git': 'git diff --no-color --no-ext-diff -U0 --ignore-space-change -- %f',
\ }

" => tmux.vim ---------------------------------------------------------------------------------------------------- {{{1

let g:tmux_navigator_no_mappings = 1

" => ultisnips.vim ----------------------------------------------------------------------------------------------- {{{1

let g:UltiSnipsExpandTrigger       = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
let g:UltiSnipsJumpForwardTrigger  = '<C-j>'
let g:UltiSnipsListSnippets        = '<C-l>'

" => vim-auto-popmenu.vim ---------------------------------------------------------------------------------------- {{{1

let g:ycm_filetype_blacklist = {'json':1, 'markdown':1, 'text':1, 'yaml':1}
let g:apc_enable_ft          = {'*':1, 'json':1, 'markdown':1, 'text':1, 'yaml':1}

" => vimwiki.vim ------------------------------------------------------------------------------------------------- {{{1

let g:vimwiki_table_mappings = 0
let g:vimwiki_list           = [
	\ {'path': '~/.local/share/wiki', 'syntax': 'markdown', 'ext': '.mdwiki'},
\]
