return {
    { -- https://github.com/chrisbra/unicode.vim
        'chrisbra/unicode.vim',
        cmd = {'UnicodeSearch', 'UnicodeTable'},
        keys = {
            {
                'ga',
                '<Plug>(UnicodeGA)',
                mode = {'n'},
                desc = 'unicode: describe',
                nowait = true,
                noremap = true,
            },
        },
    },
}
