return {
    { -- https://github.com/folke/lazy.nvim
        'folke/lazy.nvim',
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/nvim-lua/plenary.nvim
        'nvim-lua/plenary.nvim',
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/folke/neodev.nvim
        'folke/neodev.nvim',
        config = function() require('neodev').setup() end,
    },
}
