return {
    { -- https://github.com/lukas-reineke/indent-blankline.nvim
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            local ok, plugin = pcall(require, 'ibl')
            if not ok then return end

            vim.opt.list = true
            -- vim.opt.listchars:append 'eol:␤'
            -- vim.opt.listchars:append 'space:⋅'

            local highlight = {
                'RainbowViolet',
                'RainbowBlue',
                'RainbowCyan',
                'RainbowGreen',
                'RainbowYellow',
                'RainbowOrange',
                'RainbowRed',
            }

            local hooks = require('ibl.hooks')
            -- create the highlight groups in the highlight setup hook, so they are reset
            -- every time the colorscheme changes
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, 'RainbowBlue', {fg = '#3d6e96'})
                vim.api.nvim_set_hl(0, 'RainbowCyan', {fg = '#428e96'})
                vim.api.nvim_set_hl(0, 'RainbowGreen', {fg = '#76965d'})
                vim.api.nvim_set_hl(0, 'RainbowOrange', {fg = '#966e49'})
                vim.api.nvim_set_hl(0, 'RainbowRed', {fg = '#962729'})
                vim.api.nvim_set_hl(0, 'RainbowViolet', {fg = '#865196'})
                vim.api.nvim_set_hl(0, 'RainbowYellow', {fg = '#afa856'})
            end)

            local config = {
                indent = {char = '┊', highlight = highlight, tab_char = '│'},
                exclude = {
                    filetypes = {
                        'Trouble',
                        'alpha',
                        'dashboard',
                        'help',
                        'lazy',
                        'lazyterm',
                        'mason',
                        'neo-tree',
                        'notify',
                        'toggleterm',
                        'trouble',
                    },
                },
                whitespace = {highlight = highlight, remove_blankline_trail = true},
                scope = {
                    char = '┃',
                    enabled = true,
                    highlight = highlight,
                    show_end = true,
                    show_start = true,
                },
            }

            plugin.setup(config)
        end,
        event = {'BufReadPost', 'BufNewFile'},
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    -- { -- https://github.com/nmac427/guess-indent.nvim
    --     'nmac427/guess-indent.nvim',
    --     opts = {
    --         auto_cmd = true, -- Set to false to disable automatic execution
    --         buftype_exclude = { -- A list of buffer types for which the auto command gets disabled
    --             'help',
    --             'nofile',
    --             'nowrite',
    --             'prompt',
    --             'terminal',
    --         },
    --         filetype_exclude = { -- A list of filetypes for which the auto command gets disabled
    --             'fugitive',
    --             'gitcommit',
    --             'netrw',
    --             'tutor',
    --         },
    --         override_editorconfig = false, -- Set to true to override settings set by .editorconfig
    --     },
    -- },
}
