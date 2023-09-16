return {
    { -- https://github.com/nmac427/guess-indent.nvim
        'nmac427/guess-indent.nvim',
        opts = {
            auto_cmd = true, -- Set to false to disable automatic execution
            buftype_exclude = { -- A list of buffer types for which the auto command gets disabled
                'help',
                'nofile',
                'nowrite',
                'prompt',
                'terminal',
            },
            filetype_exclude = { -- A list of filetypes for which the auto command gets disabled
                'fugitive',
                'gitcommit',
                'netrw',
                'tutor',
            },
            override_editorconfig = false, -- Set to true to override settings set by .editorconfig
        },
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/lukas-reineke/indent-blankline.nvim
        'lukas-reineke/indent-blankline.nvim',
        -- event = {'BufReadPost', 'BufNewFile'},
        config = function()
            local ok, plugin = pcall(require, 'indent_blankline')
            if not ok then return end

            vim.opt.list = true
            -- vim.opt.listchars:append 'eol:␤'
            -- vim.opt.listchars:append 'space:⋅'

            local config = {
                filetype_exclude = {
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
                },
                show_current_context = true,
                show_current_context_start = true,
            }

            plugin.setup(config)
        end,
    },
}
