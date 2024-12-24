return {
    { -- https://github.com/folke/which-key.nvim
        'folke/which-key.nvim',
        keys = {
            {
                '<leader>?',
                function() require('which-key').show({global = false}) end,
                desc = 'Buffer local keymaps',
            },
        },
        config = function(_, _)
            local which_key = require('which-key')

            local config = {
                plugins = {
                    marks = true, -- shows a list of your marks on ' and `
                    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
                    spelling = {
                        enabled = true, -- enabling this will show Whitaker when pressing z= to select spelling suggestions
                        suggestions = 40, -- how many suggestions should be shown in the list?
                    },
                    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
                    -- No actual key bindings are created
                    presets = {
                        g = true, -- bindings for prefixed with g
                        motions = true, -- adds help for motions
                        nav = true, -- misc bindings to work with windows
                        operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
                        text_objects = true, -- help for text objects triggered after entering an operator
                        windows = true, -- default bindings on <c-w>
                        z = true, -- bindings for folds, spelling and others prefixed with z
                    },
                },
                -- add operators that will trigger motion and text object completion
                -- to enable all native operators, set the preset / operators plugin above
                -- operators = {gc = 'Comments'},
                -- operators = {},
                icons = {
                    breadcrumb = '>', -- symbol used in the command line area that shows your active key combo
                    group = '+', -- symbol prepended to a group
                    mappings = false,
                    separator = ':', -- symbol used between a key and it's label
                },
                keys = {
                    scroll_down = '<C-d>', -- binding to scroll down inside the popup
                    scroll_up = '<C-u>', -- binding to scroll up inside the popup
                },
                win = {
                    border = 'none', -- none, single, double, shadow
                    padding = {1, 1}, -- extra window padding [top, right, bottom, left]
                },
                layout = {
                    align = 'center', -- align columns left, center or right
                    height = {min = 4, max = 25}, -- min and max height of the columns
                    spacing = 3, -- spacing between columns
                    width = {min = 20, max = 50}, -- min and max width of the columns
                },
                -- hidden = {'<silent>', '<cmd>', '<Cmd>', '<CR>', 'call', 'lua', '^:', '^ '}, -- hide mapping boilerplate
                -- hidden = {'<cmd>', '<Cmd>', '<CR>', 'call', 'lua', '^:', '^ '}, -- hide mapping boilerplate
                show_help = true, -- show help message on the command line when the popup is visible
            }

            which_key.add({{'<leader>u', group = 'UI'}, {'<leader>t', group = ''}})

            which_key.add({
                mode = {'n'},
                nowait = true,
                remap = false,
                -- ['/'] = {'/\\v', 'search very magically'},
                {'<C-a>', 'gg<S-v>G', desc = 'select all'},
                {'<C-d>', '<C-d>zz', desc = 'scroll down and centralize'},
                {'<C-u>', '<C-u>zz', desc = 'scroll up and centralize'},
                {'<F12>', ':Inspect<CR>', desc = 'show highlight info'},

                {'<S-ScrollWheelDown>', '<C-d>', desc = 'scroll down'},
                {'<S-ScrollWheelUp>', '<C-u>', desc = 'scroll up'},

                {'<leader><leader>', group = 'Setup'},
                {'<leader><leader>.', ':execute "lcd" dir#git_root()<CR>', desc = 'cd to git-root'},
                {'<leader><leader>h', '<cmd>checkhealth<CR>', desc = 'healthcheck: open'},
                {'<leader><leader>m', ':belowright 10split term://zsh<CR>', desc = 'terminal: open'},
                {'<leader><leader>t', ':tab split<CR>', desc = 'tab: split'},
                {'<leader><leader>u', ':Lazy install<CR>', desc = 'plugins: open'},
                {'<leader><leader>v', ':tabedit $MYVIMRC<CR>', desc = 'init.vim'},

                {'<leader><CR>', '!!bash<CR>', desc = 'execute line in shell'},
                -- ['<leader>c'] = {'<cmd>Bdelete!<CR>', 'Close Buffer'},
                -- ['<leader>h'] = {'<cmd>nohlsearch<CR>', 'No Highlight'},
                {'<leader>P', '"+P', desc = 'paste from clipboard'},
                -- <leader>p = {'`[ . strpart(getregtype(), 0, 1) . `]', 'Select latest pasted'},
                {'<leader>p', '"+p', desc = 'paste from clipboard'},
                {'<leader>x', ':!xdg-open %<CR><CR>', desc = 'Open in the default program'},

                {'<leader>S', group = 'Search'},

                {'<leader>b', group = 'Buffer'},
                {'<leader>bb', ':bp|bd #<CR>', desc = 'close, keep split'},
                {'<leader>bc', ':bd<CR>', desc = 'close'},
                {'<leader>bo', BUF_ONLY, desc = 'only'},

                {'J', 'mzJ`z', desc = 'join keep cursor'},
                {'N', 'Nzzzv', desc = 'N and centralize'},
                {'Q', '<nop>', desc = 'no ex mode'},
                {'n', 'nzzzv', desc = 'n and centralize'},

                {'[', group = 'Prev'},
                {'[B', ':bfirst<CR>', desc = 'Buffer: first'},
                {'[T', ':tabfirst<CR>', desc = 'Tab: first'},
                {'[b', ':bprevious<CR>', desc = 'Buffer: prev'},
                {'[t', ':tabprevious<CR>', desc = 'Tab: prev'},

                {']', group = 'Next'},
                {']B', ':blast<CR>', desc = 'Buffer: last'},
                {']T', ':tablast<CR>', desc = 'Tab: last'},
                {']b', ':bnext<CR>', desc = 'Buffer: next'},
                {']t', ':tabnext<CR>', desc = 'Tab: next'},

                {'g', group = 'GoTo'},
                {'gJ', 'mzgJ`z', desc = 'join keep cursor'},
                {'gQ', '<nop>', desc = 'no ex mode'},
                {'gh', ':bprevious<CR>', desc = 'buffer: previous'},
                {'gl', ':bnext<CR>', desc = 'buffer: next'},
            })

            which_key.add({
                mode = {'v'},
                {'<leader><CR>', ':!bash<CR>', desc = 'execute lines in shell'},
                {'<leader>d', '"_d', desc = 'delete to black hole'},
                {'<leader>P', '"+P:let @"=@0<CR>', desc = 'paste clip, replace without copying it'},
                {'<leader>p', '"+p:let @"=@0<CR>', desc = 'paste clip, replace without copying it'},
                {'<leader>Y', 'my"+Ygv"*Y`y', desc = 'yank without jank to clipboard'},
                {'<leader>y', 'my"+ygv"*y`y', desc = 'yank without jank to clipboard'},

                {'<', '<gv', desc = 'don\'t loose selection when changing indentation'},
                {'>', '>gv', desc = 'don\'t loose selection when changing indentation'},
                {'P', 'P:let @"=@0<CR>', desc = 'paste, replace without copying it'},
                {'p', 'p:let @"=@0<CR>', desc = 'paste, replace without copying it'},
                {'Y', 'myY`y', desc = 'yank without jank'},
                {'y', 'myy`y', desc = 'yank without jank'},
                -- P = {'"zdP', 'paste replace visual without without copying it'},
                -- p = {'"zdp', 'paste replace visual selection without copying it'},
                -- P = {'"pc<C-r>0<C-\\><C-n>', 'paste replace visual selection without copying it'},
                -- p = {
                --     '<C-\\><C-n>:set paste<CR>gv"pc<C-r>0<C-\\><C-n>:set nopaste<CR>',
                --     'paste replace visual selection without copying it',
                -- },
            })

            which_key.add({
                mode = {'i'},
                {'<C-a>', '<Esc>I', desc = 'edit beginning of the line'},
                -- ['<C-d>'] = {'<C-o>x', 'delete char forward'},
                {'<C-e>', '<Esc>A', desc = 'edit end of the line'},
                {'<M-d>', '<C-o>de', desc = 'delete word forward'},
            })

            which_key.add({
                mode = {'c'},
                {'<C-a>', '<Home>', desc = 'edit beginning of the line'},
                {'<C-e>', '<End>', desc = 'edit end of the line'},
            })

            which_key.add({
                -- When text is wrapped, move by terminal rows, not lines, unless a count is provided
                expr = true,
                nowait = true,
                remap = false,
                replace_keycodes = false,
                {'j', '(v:count == 0 ? \'gj\' : \'j\')', desc = 'next line'},
                {'k', '(v:count == 0 ? \'gk\' : \'k\')', desc = 'prev line'},
            })

            which_key.add({
                nowait = true,
                remap = false,
                {'<leader>""', ':belowright vsplit<CR>', desc = 'vsplit right'},
                {'<leader>\'', ':belowright split<CR>', desc = 'split below'},
            })

            which_key.setup(config)

            -- when added with whichkey the command is not redrawn
            vim.keymap.set('n', '<leader>Sr', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/g<Left><Left>]],
                {desc = 'Replace word under cursor'})
            vim.cmd [[
                :nnoremap <nowait> / /\v
            ]]
        end,
    },
}
