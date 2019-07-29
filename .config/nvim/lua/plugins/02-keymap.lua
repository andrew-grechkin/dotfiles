return {
    { -- https://github.com/folke/which-key.nvim
        'folke/which-key.nvim',
        version = (vim.version().major < 1 and vim.version().minor < 9) and 'v1.6.1' or nil,
        config = function(_, _)
            local ok, which_key = pcall(require, 'which-key')
            if not ok then return end

            which_key.register({['<leader>u'] = {name = 'UI'}})
            which_key.register({['<leader>t'] = {name = ''}})

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
                key_labels = {
                    -- override the label used to display some keys. It doesn't effect WK in any other way.
                    -- For example:
                    -- ["<space>"] = "SPC",
                    -- ["<cr>"] = "RET",
                    -- ["<tab>"] = "TAB",
                },
                icons = {
                    breadcrumb = '>', -- symbol used in the command line area that shows your active key combo
                    group = '+', -- symbol prepended to a group
                    separator = ':', -- symbol used between a key and it's label
                },
                popup_mappings = {
                    scroll_down = '<C-d>', -- binding to scroll down inside the popup
                    scroll_up = '<C-u>', -- binding to scroll up inside the popup
                },
                window = {
                    border = 'none', -- none, single, double, shadow
                    margin = {1, 0, 1, 0}, -- extra window margin [top, right, bottom, left]
                    padding = {1, 1, 1, 1}, -- extra window padding [top, right, bottom, left]
                    position = 'bottom', -- bottom, top
                    winblend = 0,
                },
                layout = {
                    align = 'center', -- align columns left, center or right
                    height = {min = 4, max = 25}, -- min and max height of the columns
                    spacing = 3, -- spacing between columns
                    width = {min = 20, max = 50}, -- min and max width of the columns
                },
                ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
                -- hidden = {'<silent>', '<cmd>', '<Cmd>', '<CR>', 'call', 'lua', '^:', '^ '}, -- hide mapping boilerplate
                -- hidden = {'<cmd>', '<Cmd>', '<CR>', 'call', 'lua', '^:', '^ '}, -- hide mapping boilerplate
                show_help = true, -- show help message on the command line when the popup is visible
                triggers = 'auto', -- automatically setup triggers
                -- triggers = {"<leader>"} -- or specify a list manually
                triggers_blacklist = {
                    -- list of mode / prefixes that should never be hooked by WhichKey
                    -- this is mostly relevant for key maps that start with a native binding
                    -- most people should not need to change this
                    i = {'j', 'k'},
                    v = {'j', 'k'},
                },
            }

            local normal_mappings = {
                ['<leader>'] = {
                    -- ['c'] = {'<cmd>Bdelete!<CR>', 'Close Buffer'},
                    -- ['h'] = {'<cmd>nohlsearch<CR>', 'No Highlight'},
                    ['<CR>'] = {'!!bash<CR>', 'execute line in shell'},
                    ['<leader>'] = {
                        name = 'Setup',
                        ['.'] = {':execute "lcd" dir#git_root()<CR>', 'cd to git-root'},
                        ['h'] = {'<cmd>checkhealth<CR>', 'healthcheck: open'},
                        ['m'] = {':belowright 10split term://zsh<CR>', 'terminal: open'},
                        ['t'] = {':tab split<CR>', 'tab: split'},
                        ['u'] = {':Lazy install<CR>', 'plugins: open'},
                        ['v'] = {':tabedit $MYVIMRC<CR>', 'init.vim'},
                    },
                    b = {
                        name = 'Buffer',
                        ['b'] = {':bd<CR>', 'close'},
                        ['f'] = {':bp|bd #<CR>', 'close, keep split'},
                        ['o'] = {BUF_ONLY, 'only'},
                    },
                    -- p = {'`[ . strpart(getregtype(), 0, 1) . `]', 'Select latest pasted'},
                    x = {':!xdg-open %<CR><CR>', 'Open in the default program'},
                    S = {name = 'Search'},
                    P = {'"+P', 'paste from clipboard'},
                    p = {'"+p', 'paste from clipboard'},
                },
                ['['] = {
                    name = 'Prev',
                    ['B'] = {':bfirst<CR>', 'Buffer: first'},
                    ['T'] = {':tabfirst<CR>', 'Tab: first'},
                    ['b'] = {':bprevious<CR>', 'Buffer: prev'},
                    ['t'] = {':tabprevious<CR>', 'Tab: prev'},
                },
                [']'] = {
                    name = 'Next',
                    ['B'] = {':blast<CR>', 'Buffer: last'},
                    ['T'] = {':tablast<CR>', 'Tab: last'},
                    ['b'] = {':bnext<CR>', 'Buffer: next'},
                    ['t'] = {':tabnext<CR>', 'Tab: next'},
                },
                -- ['/'] = {'/\\v', 'search very magically'},
                ['<C-a>'] = {'gg<S-v>G', 'select all'},
                ['<C-d>'] = {'<C-d>zz', 'scroll down and centralize'},
                ['<C-u>'] = {'<C-u>zz', 'scroll up and centralize'},
                ['<F12>'] = {':Inspect<CR>', 'show highlight info'},
                g = {
                    name = 'GoTo',
                    J = {'mzgJ`z', 'join keep cursor'},
                    Q = {'<nop>', 'no ex mode'},
                    h = {':bprevious<CR>', 'buffer: previous'},
                    l = {':bnext<CR>', 'buffer: next'},
                },
                J = {'mzJ`z', 'join keep cursor'},
                N = {'Nzzzv', 'N and centralize'},
                Q = {'<nop>', 'no ex mode'},
                n = {'nzzzv', 'n and centralize'},

                ['<S-ScrollWheelUp>'] = {'<C-u>', 'scroll up'},
                ['<S-ScrollWheelDown>'] = {'<C-d>', 'scroll down'},
            }

            local visual_mappings = {
                ['<leader>'] = {
                    ['<CR>'] = {':!bash<CR>', 'execute lines in shell'},
                    Y = {'my"+Ygv"*Y`y', 'yank without jank to clipboard'},
                    y = {'my"+ygv"*y`y', 'yank without jank to clipboard'},
                    P = {
                        '"+P:let @"=@0<CR>',
                        'paste from clipboard, replace visual selection without copying it',
                    },
                    p = {
                        '"+p:let @"=@0<CR>',
                        'paste from clipboard, replace visual selection without copying it',
                    },
                },
                ['<'] = {'<gv', 'don\'t loose selection when changing indentation'},
                ['>'] = {'>gv', 'don\'t loose selection when changing indentation'},
                -- P = {'"zdP', 'paste replace visual without without copying it'},
                -- p = {'"zdp', 'paste replace visual selection without copying it'},
                -- P = {'"pc<C-r>0<C-\\><C-n>', 'paste replace visual selection without copying it'},
                -- p = {
                --     '<C-\\><C-n>:set paste<CR>gv"pc<C-r>0<C-\\><C-n>:set nopaste<CR>',
                --     'paste replace visual selection without copying it',
                -- },
                P = {'P:let @"=@0<CR>', 'paste, replace visual selection without copying it'},
                p = {'p:let @"=@0<CR>', 'paste, replace visual selection without copying it'},
                Y = {'myY`y', 'yank without jank'}, -- http://ddrscott.github.io/blog/2016/yank-without-jank
                y = {'myy`y', 'yank without jank'},
            }

            local insert_mappings = {
                ['<C-a>'] = {'<Esc>I', 'edit beginning of the line'},
                -- ['<C-d>'] = {'<C-o>x', 'delete char forward'},
                ['<C-e>'] = {'<Esc>A', 'edit end of the line'},
                ['<M-d>'] = {'<C-o>de', 'delete word forward'},
            }
            local command_mappings = {
                ['<C-a>'] = {'<Home>', 'edit beginning of the line'},
                ['<C-e>'] = {'<End>', 'edit end of the line'},
            }

            local normal_mappings_expr = {
                -- When text is wrapped, move by terminal rows, not lines, unless a count is provided
                ['j'] = {'(v:count == 0 ? \'gj\' : \'j\')', 'next line'},
                ['k'] = {'(v:count == 0 ? \'gk\' : \'k\')', 'prev line'},
            }

            local norm_term_mappings = {
                ['<leader>'] = {
                    ['\''] = {':belowright vsplit<CR>', 'vsplit right'},
                    ['"'] = {':belowright split<CR>', 'split below'},
                },
            }

            which_key.setup(config)
            which_key.register(normal_mappings, {mode = 'n', nowait = true, noremap = true})
            which_key.register(normal_mappings_expr,
                {mode = 'n', nowait = true, noremap = true, silent = true, expr = true})
            which_key.register(visual_mappings, {mode = 'v', nowait = true, noremap = true})
            which_key.register(insert_mappings, {mode = 'i', nowait = true, noremap = true})
            which_key.register(command_mappings, {mode = 'c', nowait = true, noremap = true})
            which_key.register(norm_term_mappings, {mode = 'n', nowait = true, noremap = true})

            -- when added with whichkey the command is not redrawn
            vim.keymap.set('n', '<leader>Sr', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/g<Left><Left>]],
                {desc = 'Replace word under cursor'})
            vim.cmd [[
                :nnoremap <nowait> / /\v
            ]]
        end,
    },
}
