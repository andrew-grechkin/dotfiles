-- url: https://github.com/hrsh7th/nvim-cmp
local status, cmp = pcall(require, 'cmp')
if not status then return end

vim.api.nvim_set_var('loaded_completion', true)

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

cmp.setup {
    confirm_opts = {behavior = cmp.ConfirmBehavior.Replace, select = false},
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
        -- ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-1), {'i', 'c'}),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(1), {'i', 'c'}),
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        -- ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping {i = cmp.mapping.abort(), c = cmp.mapping.close()},
        -- Accept currently selected item. If none selected, `select` first item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        ['<CR>'] = cmp.mapping.confirm {select = false},
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, {'i', 's'}),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
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
        {name = 'buffer', keyword_length = 4}, {name = 'dictionary', keyword_length = 4},
        {name = 'tags', keyword_length = 4}, {name = 'spell', keyword_length = 5},
        {name = 'tmux', keyword_length = 5}, {
            name = 'rg',
            keyword_length = 5,
            option = {debounce = 500, additional_arguments = '--max-depth 4'},
        },
    },
    window = {documentation = {border = {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}}},
}

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
cmp.setup.cmdline('/', {sources = {{name = 'buffer'}}})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline'}})})
