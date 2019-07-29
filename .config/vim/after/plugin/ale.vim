scriptencoding=utf-8

if plugin#is_loaded('ale')
	" register custom fixers

	function! YamlSanitize(buffer) abort
		return {
		\   'command': 'yaml-sanitize'
		\}
	endfunction

	execute ale#fix#registry#Add('yaml-sanitize', 'YamlSanitize', ['yaml'], 'Sanitize yaml')

	" settings

	let g:ale_echo_msg_format = '(%linter%) %code: %%s'
	let g:ale_fix_on_save        = 1                                           " fix files when you save them
	let g:ale_fix_on_save_ignore = {
	\   'cpp':        ['clang-format'],
	\   'css':        ['prettier'],
	\   'elixir':     ['mix_format'],
	\   'fb2':        ['xmllint'],
	\   'html':       ['prettier', 'eslint'],
	\   'javascript': ['eslint'],
	\   'json':       ['fixjson', 'jq'],
	\   'lua':        ['lua-format'],
	\   'perl':       ['perltidy'],
	\   'sh':         ['shfmt'],
	\   'typescript': ['prettier', 'deno', 'tslint', 'xo'],
	\   'vue':        ['prettier', 'eslint'],
	\   'xml':        ['xmllint'],
	\   'yaml':       ['yaml-sanitize', 'prettier'],
	\}
	let g:ale_fixers = {
	\   '*':          [                             'remove_trailing_lines', 'trim_whitespace'],
	\   'cpp':        ['clang-format',              'remove_trailing_lines', 'trim_whitespace'],
	\   'css':        ['prettier',                  'remove_trailing_lines', 'trim_whitespace'],
	\   'elixir':     ['mix_format',                'remove_trailing_lines', 'trim_whitespace'],
	\   'fb2':        ['xmllint',                   'remove_trailing_lines', 'trim_whitespace'],
	\   'html':       ['prettier', 'eslint',        'remove_trailing_lines', 'trim_whitespace'],
	\   'javascript': ['eslint',                    'remove_trailing_lines', 'trim_whitespace'],
	\   'json':       ['fixjson', 'jq',             'remove_trailing_lines', 'trim_whitespace'],
	\   'lua':        ['lua-format',                'remove_trailing_lines', 'trim_whitespace'],
	\   'perl':       ['perltidy',                  'remove_trailing_lines', 'trim_whitespace'],
	\   'python':     [
	\		'add_blank_lines_for_python_control_statements',
	\		'isort',
	\		'black',
	\	],
	\   'sh':         ['shfmt',                     'remove_trailing_lines', 'trim_whitespace'],
	\   'typescript': [            'eslint',        'remove_trailing_lines', 'trim_whitespace'],
	\   'vue':        ['prettier', 'eslint',        'remove_trailing_lines', 'trim_whitespace'],
	\   'xml':        ['xmllint',                   'remove_trailing_lines', 'trim_whitespace'],
	\   'yaml':       ['prettier',                  'remove_trailing_lines', 'trim_whitespace'],
	\}
	"\		'autoimport',
	"\		'autoflake',

"	let g:ale_linters_explicit = 1
	let g:ale_linters          = {
	\   'html':       ['eslint', 'stylelint'],
	\   'perl':       ['perl', 'perlcritic', 'perlart'],
	\   'typescript': ['eslint'],
	\}
	" let g:ale_linter_aliases   = {
	" \   'vue':        ['vue', 'javascript'],
	" \}

	let g:ale_sign_error            = '✘'
	let g:ale_sign_warning          = '✱'
	let g:ale_set_loclist           = 1
	let g:ale_set_quickfix          = 1
	let g:ale_open_list             = 1
	let g:ale_keep_list_window_open = 0
	let g:ale_list_window_size      = 4

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
	" ale_javascript
"	let g:ale_javascript_eslint_options    = '--resolve-plugins-relative-to=$(npm get prefix)/lib'
"	let g:ale_javascript_eslint_use_global = 1
	" ale_sh
	let g:ale_sh_shellcheck_dialect     = 'bash'
	" ale_json
	let g:ale_json_jq_options           = '-S --indent 4'
	let g:ale_json_spectral_use_global  = 1
	" ale_yaml
	let g:ale_yaml_spectral_use_global  = 1

	nmap <silent> tt <Plug>(ale_fix)
endif
