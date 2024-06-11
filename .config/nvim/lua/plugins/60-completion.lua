return {
    { -- https://github.com/hrsh7th/nvim-cmp
        'hrsh7th/nvim-cmp',
        dependencies = {
            'andersevenrud/cmp-tmux',
            'f3fora/cmp-spell',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-path',
            'lukas-reineke/cmp-rg',
            'quangnguyen30192/cmp-nvim-tags',
            { -- https://github.com/saadparwaiz1/cmp_luasnip
                'saadparwaiz1/cmp_luasnip',
                dependencies = {
                    { -- https://github.com/L3MON4D3/LuaSnip
                        'L3MON4D3/LuaSnip',
                        -- dependencies = {
                        --     { -- https://github.com/rafamadriz/friendly-snippets
                        --         'rafamadriz/friendly-snippets',
                        --     },
                        --     { -- https://github.com/andrew-grechkin/vim-snippets
                        --         'andrew-grechkin/vim-snippets',
                        --     },
                        -- },
                        config = function()
                            local plugin = require('luasnip')
                            -- require('luasnip.loaders.from_vscode').lazy_load()
                            require('luasnip.loaders.from_snipmate').lazy_load()

                            vim.keymap.set({'i', 's'}, '<C-j>', function()
                                plugin.expand_or_jump(1)
                            end, {silent = true})
                            -- vim.keymap.set({'i', 's'}, '<C-k>', function() plugin.jump(-1) end, {
                            --     silent = true,
                            -- })
                        end,
                    },
                },
            },
            { -- https://github.com/kristijanhusak/vim-dadbod-completion
                'kristijanhusak/vim-dadbod-completion',
                ft = {'sql', 'mysql', 'plsql'},
                lazy = true,
            },
        },
        event = {'BufReadPost', 'BufNewFile'},
        config = function()
            local ok, plugin = pcall(require, 'cmp')
            if not ok then return end

            -- let g:loaded_completion = 1
            -- vim.api.nvim_set_var('loaded_completion', true)
            local kind_icons = {
                Class = ' (class)',
                Cody = '󰧑 (cody)',
                Color = ' (color)',
                Constant = ' (const)',
                Constructor = ' (cnstr)',
                Enum = ' (enum)',
                EnumMember = ' (enumv)',
                Event = ' (event)',
                Field = ' (field)',
                File = ' (file)',
                Folder = ' (dir)',
                Function = ' (func)',
                Interface = 'ﰮ (iface)',
                Keyword = ' (keywd)',
                Method = 'm (method)',
                Module = ' (module)',
                Operator = ' (oprtr)',
                Property = ' (prop)',
                Reference = ' (ref)',
                Snippet = ' (snip)',
                Struct = ' (struct)',
                Text = ' (text)',
                TypeParameter = ' (type)',
                Unit = ' (unit)',
                Value = ' (value)',
                Variable = ' (var)',
            }

            local rg_conf = {
                name = 'rg',
                keyword_length = 5,
                option = {debounce = 500, additional_arguments = '--max-depth 8'},
            }

            local config = {
                completion = {keyword_length = 2},
                confirm_opts = {behavior = plugin.ConfirmBehavior.Replace, select = false},
                experimental = {ghost_text = true, native_menu = false},
                formatting = {
                    fields = {'kind', 'abbr', 'menu'},
                    format = function(entry, vim_item)
                        vim_item.kind = kind_icons[vim_item.kind] and string.format('%s', kind_icons[vim_item.kind]) or
                                            vim_item.kind
                        vim_item.menu = ({
                            buffer = '[buff]',
                            cody = '[cody]',
                            dictionary = '[dict]',
                            luasnip = '[snip]',
                            nvim_lua = '[nvim]',
                            nvim_lsp = '[lsp] ',
                            path = '[path]',
                            rg = '[grep]',
                            spell = '[spel]',
                            tags = '[tags]',
                            tmux = '[tmux]',
                            ultisnips = '[snip]',
                            ['vim-dadbod-completion'] = '[sql] ',
                        })[entry.source.name]
                        return vim_item
                    end,
                },
                mapping = {
                    -- ['<C-Space>'] = plugin.mapping(plugin.mapping.complete(), {'i', 'c'}),
                    ['<C-Space>'] = plugin.mapping.complete(),
                    ['<C-e>'] = plugin.mapping {
                        i = plugin.mapping.abort(),
                        c = plugin.mapping.close(),
                    },
                    ['<C-d>'] = plugin.mapping(plugin.mapping.scroll_docs(4), {'i', 'c'}),
                    ['<C-u>'] = plugin.mapping(plugin.mapping.scroll_docs(-4), {'i', 'c'}),
                    ['<C-n>'] = plugin.mapping.select_next_item(),
                    ['<C-p>'] = plugin.mapping.select_prev_item(),
                    -- ['<C-y>'] = plugin.config.disable, -- Specify `plugin.config.disable` if you want to remove the default `<C-y>` mapping.
                    -- Accept currently selected item. If none selected, `select` first item.
                    -- Set `select` to `false` to only confirm explicitly selected items.
                    ['<CR>'] = plugin.mapping.confirm {select = false},
                    ['<Tab>'] = plugin.mapping(function(fallback)
                        if plugin.visible() then
                            plugin.select_next_item()
                        else
                            fallback()
                        end
                    end, {'i', 's'}),
                    ['<S-Tab>'] = plugin.mapping(function(fallback)
                        if plugin.visible() then
                            plugin.select_prev_item()
                        else
                            fallback()
                        end
                    end, {'i', 's'}),
                },
                snippet = {
                    expand = function(args)
                        -- vim.fn['vsnip#anonymous'](args.body) -- For `vsnip` users.
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                        -- vim.fn['UltiSnips#Anon'](args.body) -- For `ultisnips` users.
                    end,
                },
                sources = {
                    {name = 'luasnip', keyword_length = 2},
                    {name = 'vim-dadbod-completion'},
                    {name = 'cody'},
                    {name = 'nvim_lsp'},
                    {name = 'nvim_lua'},
                    {name = 'path'},
                    {name = 'buffer', keyword_length = 3},
                    {name = 'dictionary', keyword_length = 4},
                    {name = 'tags', keyword_length = 4},
                    {name = 'spell', keyword_length = 5},
                    {name = 'tmux', keyword_length = 5},
                    rg_conf,
                },
                window = {
                    completion = plugin.config.window.bordered(),
                    documentation = plugin.config.window.bordered(),
                },
            }

            plugin.setup(config)

            -- local cmp_dictionary_status, cmp_dictionary = pcall(require, 'cmp_dictionary')
            -- if (cmp_dictionary_status) then
            --     cmp_dictionary.setup({
            --         dic = {
            --             -- ['*'] = 'path',
            --             -- ['markdown'] = {'path', 'path'},
            --             -- ['javascript,typescript'] = {'path'},
            --             ['perl'] = {'~/.local/share/vim-dict/perl'},
            --         },
            --         exact = 2,
            --         async = false,
            --         capacity = 5,
            --         debug = false,
            --     })
            -- end

            -- -- use only together or this will breake native command autocomplete after first usage
            -- -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
            -- plugin.setup.cmdline({'/', '?'},
            --     {mapping = plugin.mapping.preset.cmdline(), sources = {{name = 'buffer'}, rg_conf}})
            -- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            -- plugin.setup.cmdline(':', {
            --     mapping = plugin.mapping.preset.cmdline(),
            --     sources = plugin.config.sources({{name = 'path'}}, {
            --         {name = 'cmdline'},
            --         {name = 'buffer'},
            --         rg_conf,
            --     }),
            -- })
        end,
    },
}
