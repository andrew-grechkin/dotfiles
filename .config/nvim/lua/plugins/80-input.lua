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
        config = function()
            local wk_ok, which_key = pcall(require, 'which-key')
            if wk_ok then
                local normal_mappings = {['<leader>'] = {a = {'<Plug>(EasyAlign)', 'easy-align'}}}
                local visual_mappings = {['<leader>'] = {a = {'<Plug>(EasyAlign)', 'easy-align'}}}

                which_key.register(normal_mappings, {mode = 'n', nowait = true, noremap = true})
                which_key.register(visual_mappings, {mode = 'x', nowait = true, noremap = true})
            end
        end,
    },
}
