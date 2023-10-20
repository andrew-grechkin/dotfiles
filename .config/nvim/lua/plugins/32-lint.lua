return {
    { -- https://github.com/dense-analysis/ale
        'dense-analysis/ale',
        config = function()
            vim.api.nvim_exec([[
" register custom fixers

function! YamlSanitize(buffer) abort
	return {
	\   'command': 'yaml-sanitize'
	\}
endfunction
execute ale#fix#registry#Add('yaml-sanitize', 'YamlSanitize', ['yaml'], 'Sanitize yaml')

function! ShellHarden(buffer) abort
	return {
	\   'command': 'shellharden --transform ""'
	\}
endfunction
execute ale#fix#registry#Add('shellharden', 'ShellHarden', ['sh'], 'Shell harden')

function! BeautySh(buffer) abort
	return {
	\   'command': 'beautysh -t -i 4 -s fnpar -c -'
	\}
endfunction
execute ale#fix#registry#Add('beautysh', 'BeautySh', ['sh'], 'Beauty sh')

execute ale#fix#registry#Add('mysql_sqlfluff', 'ale_fixers#mysql#sqlfluff#Fix', ['mysql'], 'Fix MySQL files with sqlfluff.')

call ale#linter#Define('mysql', {
\   'name': 'sqlfluff',
\   'executable': function('ale_linters#mysql#sqlfluff#Executable'),
\   'command': function('ale_linters#mysql#sqlfluff#Command'),
\   'callback': 'ale_linters#mysql#sqlfluff#Handle',
\})

function! Sql_Formatter(buffer) abort
	return {
	\   'command': 'sql-formatter -l mysql -c ~/.config/sql-formatter.json'
	\}
endfunction
execute ale#fix#registry#Add('sql-formatter', 'Sql_Formatter', ['mysql', 'sql'], 'Format SQL')
]], false)

            vim.api.nvim_create_user_command('ALEToggleBufferFixers',
                'let b:ale_fix_on_save=!get(b:, \'ale_fix_on_save\', g:ale_fix_on_save)', {
                    bang = true,
                })

            local wk_ok, which_key = pcall(require, 'which-key')
            if wk_ok then
                local normal_mappings = {t = {t = {'<Plug>(ale_fix)', 'ALE: fix'}}}
                which_key.register(normal_mappings, {mode = 'n', nowait = true, noremap = true})
            end

            vim.g.ale_echo_msg_format = '(%linter%) %code: %%s'
            vim.g.ale_fix_on_save = 1 -- fix files when you save them
            vim.g.ale_fix_on_save_ignore = {
                ['cpp'] = {'clang-format'},
                ['css'] = {'prettier'},
                ['elixir'] = {'mix_format'},
                ['fb2'] = {'xmllint'},
                ['html'] = {'prettier', 'eslint'},
                ['javascript'] = {'prettier'},
                ['json'] = {'jq'},
                ['lua'] = {'lua-format'},
                ['mysql'] = {'sql-formatter', 'mysql_sqlfluff'},
                ['perl'] = {'perltidy'},
                ['python'] = {'black'},
                ['sh'] = {'shellharden', 'beautysh'},
                ['sql'] = {'sql-formatter', 'sqlfluff'},
                ['typescript'] = {'prettier', 'deno', 'tslint', 'xo'},
                ['vue'] = {'prettier', 'eslint'},
                ['xml'] = {'xmllint'},
                ['yaml'] = {'yaml-sanitize'},
            }

            vim.g.ale_fixers = {
                ['*'] = {'remove_trailing_lines', 'trim_whitespace'},
                ['cpp'] = {'clang-format', 'remove_trailing_lines', 'trim_whitespace'},
                ['css'] = {'prettier', 'remove_trailing_lines', 'trim_whitespace'},
                ['elixir'] = {'mix_format', 'remove_trailing_lines', 'trim_whitespace'},
                ['fb2'] = {'xmllint', 'remove_trailing_lines', 'trim_whitespace'},
                ['html'] = {'prettier', 'eslint', 'remove_trailing_lines', 'trim_whitespace'},
                ['javascript'] = {'prettier', 'remove_trailing_lines', 'trim_whitespace'},
                ['json'] = {'fixjson', 'jq', 'remove_trailing_lines', 'trim_whitespace'},
                ['lua'] = {'lua-format', 'remove_trailing_lines', 'trim_whitespace'},
                ['mysql'] = {
                    'sql-formatter',
                    'mysql_sqlfluff',
                    'remove_trailing_lines',
                    'trim_whitespace',
                },
                ['perl'] = {'perltidy', 'remove_trailing_lines', 'trim_whitespace'},
                ['python'] = {'isort', 'black', 'remove_trailing_lines', 'trim_whitespace'},
                ['sh'] = {'shellharden', 'beautysh', 'remove_trailing_lines', 'trim_whitespace'},
                ['sql'] = {'sql-formatter', 'sqlfluff', 'remove_trailing_lines', 'trim_whitespace'},
                ['typescript'] = {'eslint', 'remove_trailing_lines', 'trim_whitespace'},
                ['vue'] = {'prettier', 'eslint', 'remove_trailing_lines', 'trim_whitespace'},
                ['xml'] = {'xmllint', 'remove_trailing_lines', 'trim_whitespace'},
                ['yaml'] = {'yamlfix', 'yaml-sanitize', 'remove_trailing_lines', 'trim_whitespace'},
            }
            -- vim.g.ale_linters_explicit = 1
            -- let g:ale_linters          = {
            -- \   'html':       ['eslint', 'stylelint'],
            -- \   'perl':       ['perl', 'perlcritic', 'perlart'],
            -- \   'typescript': ['eslint'],
            -- \}
            -- let g:ale_linter_aliases   = {
            -- \   'vue':        ['vue', 'javascript'],
            -- \}

            vim.g.ale_sign_error = '✘'
            vim.g.ale_sign_warning = '✱'
            vim.g.ale_set_loclist = 1
            vim.g.ale_set_quickfix = 1
            vim.g.ale_open_list = 1
            vim.g.ale_keep_list_window_open = 0
            vim.g.ale_list_window_size = 4

            -- ale_sql_sqlfluff
            -- vim.g.ale_sql_sqlfluff_options = ''

            -- ale_cpp
            vim.g.ale_c_build_dir_names = {'.build', 'build', '.build-Debug', '.build-Release'}
            vim.g.ale_c_parse_compile_commands = 1
            vim.g.ale_c_parse_makefile = 1
            vim.g.ale_cpp_build_dir_names = {'.build', 'build', '.build-Debug', '.build-Release'}
            vim.g.ale_cpp_options = '-std=c++20 -Wall -I ./include -I ./src/include'
            vim.g.ale_cpp_cc_options = '-std=c++20 -Wall -I ./include -I ./src/include'
            vim.g.ale_cpp_clang_options = '-std=c++20 -Wall -I ./include -I ./src/include'
            vim.g.ale_cpp_clangcheck_options =
                '--extra-arg=-std=c++20 --extra-arg=-Wall --extra-arg=-I./include --extra-arg=-I./src/include'
            -- vim.g.ale_cpp_clangd_options         = ''
            vim.g.ale_cpp_clangtidy_options = '-std=c++20 -Wall -I ./include -I ./src/include'
            vim.g.ale_cpp_gcc_options = '-std=c++20 -Wall -I ./include -I ./src/include'
            vim.g.ale_cpp_parse_compile_commands = 1
            vim.g.ale_cpp_parse_makefile = 1
            -- ale_javascript
            vim.g.ale_javascript_eslint_options = '-c ~/.config/.eslintrc.js'
            vim.g.ale_javascript_prettier_options = '--config ~/.config/.prettierrc.yaml'
            -- ale-lua-luacheck
            vim.g.ale_lua_luacheck_options = '--allow_defined_top'
            -- ale_markdown
            vim.g.ale_markdown_markdownlint_options = '--config ~/.config/markdownlint.yaml'
            -- ale_perl
            vim.g.ale_perl_perl_executable = 'perl'
            vim.g.ale_perl_perl_options = '-cw -Ilib'
            vim.g.ale_perl_perlcritic_showrules = 1
            -- ale_sh
            vim.g.ale_sh_shellcheck_dialect = 'bash'
            -- ale_sh_fmt
            vim.g.ale_sh_shfmt_options = '--binary-next-line --case-indent --keep-padding'
            -- ale_json
            vim.g.ale_json_jq_options = '-S --indent 2'
            vim.g.ale_json_spectral_use_global = 1
            -- ale_yaml
            vim.g.ale_yaml_spectral_use_global = 1
        end,
    },
}
