scriptencoding=utf-8
if plugin#is_loaded('ale')
	let g:ale_fix_on_save        = 1                                           " fix files when you save them
	let g:ale_fix_on_save_ignore = {
	\   'cpp':        ['clang-format'],
	\   'perl':       ['perltidy'],
	\   'typescript': ['tsfmt'],
	\}
	let g:ale_fixers = {
	\   '*':          ['remove_trailing_lines', 'trim_whitespace'],
	\   'cpp':        ['clang-format', 'remove_trailing_lines', 'trim_whitespace'],
	\   'perl':       ['remove_trailing_lines', 'trim_whitespace', 'perltidy'],
	\   'typescript': ['remove_trailing_lines', 'trim_whitespace', 'tsfmt'],
	\}

"	let g:ale_linters_explicit = 1
	let g:ale_linters          = {
	\   'perl':       ['perl', 'perlcritic', 'perlart'],
	\   'typescript': ['tslint'],
	\}

	let g:ale_sign_error            = '✘'
	let g:ale_sign_warning          = '❇'
	let g:ale_set_loclist           = 1
	let g:ale_set_quickfix          = 0
	let g:ale_open_list             = 1
	let g:ale_keep_list_window_open = 0
	let g:ale_list_window_size      = 5

	" ale_cpp
	let g:ale_c_build_dir_names          = ['.build', 'build', '.build-Debug', '.build-Release']
	let g:ale_c_parse_compile_commands   = 1
	let g:ale_c_parse_makefile           = 1
	let g:ale_cpp_build_dir_names        = ['.build', 'build', '.build-Debug', '.build-Release']
	let g:ale_cpp_options                = '-std=c++20 -Wall -I ./include -I ./src/include'
	let g:ale_cpp_cc_options             = '-std=c++20 -Wall -I ./include -I ./src/include'
	let g:ale_cpp_clang_options          = '-std=c++20 -Wall -I ./include -I ./src/include'
	let g:ale_cpp_clangcheck_options     = '--extra-arg=-std=c++20 --extra-arg=-Wall --extra-arg=-I./include --extra-arg=-I./src/include'
"	let g:ale_cpp_clangd_options         = ''
	let g:ale_cpp_clangtidy_options      = '-std=c++20 -Wall -I ./include -I ./src/include'
	let g:ale_cpp_gcc_options            = '-std=c++20 -Wall -I ./include -I ./src/include'
	let g:ale_cpp_parse_compile_commands = 1
	let g:ale_cpp_parse_makefile         = 1
	" ale_perl
	let g:ale_perl_perl_executable      = 'perl'
	let g:ale_perl_perl_options         = '-cw -Ilib'
	let g:ale_perl_perlcritic_showrules = 1

	let g:ale_sh_shellcheck_dialect = 'b:is_bash'

	nmap <silent> tt <Plug>(ale_fix)
endif
