return {
    { -- https://github.com/Raimondi/delimitMate
        'Raimondi/delimitMate',
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/tpope/vim-repeat
        'tpope/vim-repeat',
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/tpope/vim-surround
        'tpope/vim-surround',
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/junegunn/vim-easy-align
        'junegunn/vim-easy-align',
        keys = {
            {
                '<leader>a',
                '<Plug>(EasyAlign)',
                mode = {'n', 'x'},
                desc = 'easy-align',
                nowait = true,
                noremap = true,
            },
        },
    },
}
