return {
    { -- https://github.com/chrisbra/unicode.vim
        'chrisbra/unicode.vim',
        config = function()
            local wk_ok, which_key = pcall(require, 'which-key')
            if wk_ok then
                local normal_mappings = {['g'] = {a = {'<Plug>(UnicodeGA)', 'unicode: describe'}}}

                which_key.register(normal_mappings, {mode = 'n', nowait = true, noremap = true})
            end
        end,
    },
}
