" => man.vim ------------------------------------------------------------------------------------------------------ {{{1

let g:man_hardwrap = 1

" => perl.vim ----------------------------------------------------------------------------------------------------- {{{1

" man: ft-perl-syntax
let perl_fold                  = 1
let perl_include_pod           = 0
let perl_no_extended_vars      = 1
let perl_no_scope_in_variables = 1
let perl_nofold_packages       = 1

" => vim-grepper -------------------------------------------------------------------------------------------------- {{{1

let g:grepper = {}

" => vim-grepper -------------------------------------------------------------------------------------------------- {{{1

let g:perl_compiler_force_warnings = 0

" => python.vim --------------------------------------------------------------------------------------------------- {{{1

let g:loaded_python_provider = 0
let g:python_host_prog  = 'python'
let g:python3_host_prog = 'python'

" => tmux.vim ----------------------------------------------------------------------------------------------------- {{{1

let g:tmux_navigator_no_mappings = 1

" => ultisnips.vim ------------------------------------------------------------------------------------------------ {{{1

let g:UltiSnipsExpandTrigger       = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
let g:UltiSnipsJumpForwardTrigger  = '<C-j>'
let g:UltiSnipsListSnippets        = '<C-l>'

" => vimwiki.vim -------------------------------------------------------------------------------------------------- {{{1

let g:vimwiki_global_ext     = 0
let g:vimwiki_table_mappings = 0
let g:vimwiki_list           = [
	\ {'path': '~/.local/share/wiki', 'syntax': 'markdown', 'ext': '.mdwiki'},
\]
