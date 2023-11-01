return {
    { -- https://github.com/folke/lazy.nvim
        'folke/lazy.nvim',
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/nvim-lua/plenary.nvim
        'nvim-lua/plenary.nvim',
        lazy = true,
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/folke/neodev.nvim
        'folke/neodev.nvim',
        lazy = true,
        config = function() require('neodev').setup({
            library = {plugins = {'neotest'}, types = true},
        }) end,
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/lambdalisue/suda.vim
        'lambdalisue/suda.vim',
    },
}
