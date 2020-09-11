if plugin#is_loaded('ctrlsf.vim')
	let g:ctrlsf_auto_focus = {
		\ 'at':                 'done',
		\ 'duration_less_than': 2000
	\ }
	"let g:ctrlsf_debug_mode         = 1
	let g:ctrlsf_default_root       = 'project+wf'
	"let g:ctrlsf_default_view_mode  = 'compact'
	let g:ctrlsf_extra_backend_args = {
		\ 'ag': '--hidden --nofollow',
		\ 'rg': '--hidden',
	\ }
	let g:ctrlsf_extra_root_markers = ['.git', '.hg', '.svn', '.cache']
	let g:ctrlsf_follow_symlinks    = 0
	let g:ctrlsf_ignore_dir         = ['.git', 'bower_components', 'node_modules']
	let g:ctrlsf_parse_speed        = 100
	let g:ctrlsf_position           = 'bottom'

	nmap <leader>f <Plug>CtrlSFPrompt
	vmap <leader>f <Plug>CtrlSFVwordExec
endif
