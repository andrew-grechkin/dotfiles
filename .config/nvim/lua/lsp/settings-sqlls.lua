return {
    cmd = {'sql-language-server', 'up', '--method', 'stdio'},
    filetypes = {'sql', 'mysql'},
    root_dir = GET_PROJECT_DIR,
    settings = {
        ['sqlLanguageServer'] = {
            lint = {
                rules = {
                    ['align-column-to-the-first'] = 'error',
                    ['align-where-clause-to-the-first'] = 'off',
                    ['column-new-line'] = 'error',
                    ['linebreak-after-clause-keyword'] = 'off',
                    ['reserved-word-case'] = {'error', 'upper'},
                    ['space-surrounding-operators'] = 'error',
                    ['where-clause-new-line'] = 'error',
                },
            },
        },
    },
    set_prepare = function(_, _) end,
    set_on_attach = function(_, _) end,
}
