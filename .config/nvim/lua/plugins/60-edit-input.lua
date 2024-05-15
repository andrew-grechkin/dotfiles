return {
    { -- https://github.com/Raimondi/delimitMate
        'Raimondi/delimitMate',
        event = {'BufReadPost', 'BufNewFile'},
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/tpope/vim-repeat
        'tpope/vim-repeat',
        event = {'BufReadPost', 'BufNewFile'},
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/tpope/vim-surround
        'tpope/vim-surround',
        event = {'BufReadPost', 'BufNewFile'},
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
