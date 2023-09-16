return {
    { -- url: https://github.com/hrsh7th/nvim-cmp
        'hrsh7th/nvim-cmp',
        dependencies = {
            'andersevenrud/cmp-tmux', 'f3fora/cmp-spell', 'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-cmdline', 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-path', 'lukas-reineke/cmp-rg', 'quangnguyen30192/cmp-nvim-tags',
            'quangnguyen30192/cmp-nvim-ultisnips', -- 'uga-rosa/cmp-dictionary'
            'SirVer/ultisnips', 'andrew-grechkin/vim-snippets',
        },
        config = function()
            local ok, plugin = pcall(require, 'cmp')
            if not ok then return end

            -- let g:loaded_completion = 1
            -- vim.api.nvim_set_var('loaded_completion', true)
            local kind_icons = {
                Class = '',
                Color = '',
                Constant = '',
                Constructor = '',
                Enum = '',
                EnumMember = '',
                Event = '',
                Field = '',
                File = '',
                Folder = '',
                Function = '',
                Interface = 'ﰮ',
                Keyword = '',
                Method = 'm',
                Module = '',
                Operator = '',
                Property = '',
                Reference = '',
                Snippet = '',
                Struct = '',
                Text = '',
                TypeParameter = '',
                Unit = '',
                Value = '',
                Variable = '',
            }

            local config = {
                confirm_opts = {behavior = plugin.ConfirmBehavior.Replace, select = false},
                experimental = {ghost_text = true, native_menu = false},
                formatting = {
                    fields = {'kind', 'abbr', 'menu'},
                    format = function(entry, vim_item)
                        vim_item.kind = string.format('%s', kind_icons[vim_item.kind])
                        vim_item.menu = ({
                            buffer = '[buff]',
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
                        })[entry.source.name]
                        return vim_item
                    end,
                },
                mapping = {
                    -- ['<C-Space>'] = plugin.mapping(plugin.mapping.complete(), {'i', 'c'}),
                    ['<C-b>'] = plugin.mapping(plugin.mapping.scroll_docs(-1), {'i', 'c'}),
                    ['<C-f>'] = plugin.mapping(plugin.mapping.scroll_docs(1), {'i', 'c'}),
                    ['<C-j>'] = plugin.mapping.select_next_item(),
                    ['<C-k>'] = plugin.mapping.select_prev_item(),
                    -- ['<C-y>'] = plugin.config.disable, -- Specify `plugin.config.disable` if you want to remove the default `<C-y>` mapping.
                    ['<C-e>'] = plugin.mapping {
                        i = plugin.mapping.abort(),
                        c = plugin.mapping.close(),
                    },
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
                        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                        vim.fn['UltiSnips#Anon'](args.body) -- For `ultisnips` users.
                    end,
                },
                sources = {
                    {name = 'ultisnips'}, {name = 'nvim_lsp'}, {name = 'nvim_lua'}, {name = 'path'},
                    {name = 'buffer', keyword_length = 4},
                    {name = 'dictionary', keyword_length = 4}, {name = 'tags', keyword_length = 4},
                    {name = 'spell', keyword_length = 5}, {name = 'tmux', keyword_length = 5}, {
                        name = 'rg',
                        keyword_length = 5,
                        option = {debounce = 500, additional_arguments = '--max-depth 4'},
                    },
                },
                window = {documentation = {border = {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}}},
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

            -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
            -- plugin.setup.cmdline('/', { sources = { { name = 'buffer' } } })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            -- plugin.setup.cmdline(':', { sources = plugin.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }) })
        end,
    },
}
