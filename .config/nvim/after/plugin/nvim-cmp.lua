-- url: https://github.com/hrsh7th/nvim-cmp
local status, cmp = pcall(require, 'cmp')
if (not status) then return end

vim.api.nvim_set_var('loaded_completion', true)

-- local snip_status_ok, luasnip = pcall(require, "luasnip")
-- if not snip_status_ok then
--   return
-- end

-- require("luasnip/loaders/from_vscode").lazy_load()

local check_backspace = function()
    local col = vim.fn.col '.' - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match '%s'
end

-- find more here: https://www.nerdfonts.com/cheat-sheet
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
    snippet = {
        expand = function(args)
            -- vim.fn['vsnip#anonymous'](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            vim.fn['UltiSnips#Anon'](args.body) -- For `ultisnips` users.
        end,
    },
    mapping = {
        -- ['<C-k>'] = cmp.mapping.select_prev_item(),
        -- ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-1), {'i', 'c'}),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(1), {'i', 'c'}),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
        -- ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        },
        -- Accept currently selected item. If none selected, `select` first item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        ['<CR>'] = cmp.mapping.confirm {select = true},
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
    formatting = {
        fields = {'kind', 'abbr', 'menu'},
        format = function(entry, vim_item)
            vim_item.kind = string.format('%s', kind_icons[vim_item.kind])
            vim_item.menu = ({
                buffer = '[buff]',
                dictionary = '[dict]',
                luasnip = '[snip]',
                nvim_lua = '[nvim]',
                path = '[path]',
                spell = '[spel]',
                tags = '[tags]',
                ultisnips = '[snip]',
            })[entry.source.name]
            return vim_item
        end,
    },
    sources = {
        {name = 'ultisnips'}, {name = 'dictionary', keyword_length = 2},
        {name = 'nvim_lua'}, {name = 'tags'}, {name = 'buffer'},
        {name = 'spell'}, {name = 'path'},
    },
    confirm_opts = {behavior = cmp.ConfirmBehavior.Replace, select = false},
    documentation = {border = {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}},
    experimental = {ghost_text = true, native_menu = false},
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
cmp.setup.cmdline(':', {
    sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline'}}),
})
