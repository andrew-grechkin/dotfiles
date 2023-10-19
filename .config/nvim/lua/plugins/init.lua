return {
    { -- https://github.com/folke/lazy.nvim
        'folke/lazy.nvim',
    },
    { -- https://github.com/ThePrimeagen/vim-be-good
        'ThePrimeagen/vim-be-good'
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/nvim-lua/plenary.nvim
        'nvim-lua/plenary.nvim',
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/folke/neodev.nvim
        'folke/neodev.nvim',
        config = function() require('neodev').setup({
            library = {plugins = {'neotest'}, types = true},
        }) end,
    },
    { -- https://github.com/lambdalisue/suda.vim
        'lambdalisue/suda.vim',
    },
}
