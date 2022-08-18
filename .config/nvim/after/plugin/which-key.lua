-- url: https://github.com/folke/which-key.nvim
local ok, which_key = pcall(require, 'which-key')
if (not ok) then return end

local setup = {
    plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
            enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20, -- how many suggestions should be shown in the list?
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
    operators = {},
    key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        -- For example:
        -- ["<space>"] = "SPC",
        -- ["<cr>"] = "RET",
        -- ["<tab>"] = "TAB",
    },
    icons = {
        breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
        group = '+', -- symbol prepended to a group
        separator = '➜', -- symbol used between a key and it's label
    },
    popup_mappings = {
        scroll_down = '<c-d>', -- binding to scroll down inside the popup
        scroll_up = '<c-u>', -- binding to scroll up inside the popup
    },
    window = {
        border = 'none', -- none, single, double, shadow
        position = 'bottom', -- bottom, top
        margin = {1, 0, 1, 0}, -- extra window margin [top, right, bottom, left]
        padding = {1, 1, 1, 1}, -- extra window padding [top, right, bottom, left]
        winblend = 0,
    },
    layout = {
        height = {min = 4, max = 25}, -- min and max height of the columns
        width = {min = 20, max = 50}, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = 'center', -- align columns left, center or right
    },
    ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
    -- hidden = {'<silent>', '<cmd>', '<Cmd>', '<CR>', 'call', 'lua', '^:', '^ '}, -- hide mapping boilerplate
    hidden = {'<cmd>', '<Cmd>', '<CR>', 'call', 'lua', '^:', '^ '}, -- hide mapping boilerplate
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

local leader_opts = {
    buffer = nil,
    mode = 'n',
    noremap = true,
    nowait = true,
    prefix = '<leader>',
    silent = true,
}

local normal_opts = {
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    mode = 'n', -- NORMAL mode
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
    silent = true, -- use `silent` when creating keymaps
}

-- local terminal_opts = {
--     buffer = nil,
--     mode = 't',
--     noremap = true,
--     nowait = true,
--     silent = true,
-- }

local insert_opts = {
    buffer = nil,
    mode = 'i',
    noremap = true,
    nowait = true,
    silent = true,
}

local visual_opts = {
    buffer = nil,
    mode = 'v',
    noremap = true,
    nowait = true,
    silent = true,
}

local leader_mappings = {
    -- ['a'] = {'<cmd>Alpha<CR>', 'Alpha'},
    -- ['b'] = {
    --     '<cmd>lua require(\'telescope.builtin\').buffers(require(\'telescope.themes\').get_dropdown{previewer = false})<CR>',
    --     'Buffers',
    -- },
    -- ['e'] = {'<cmd>NvimTreeToggle<CR>', 'Explorer'},
    -- ['w'] = {'<cmd>w!<CR>', 'Save'},
    -- ['q'] = {'<cmd>q!<CR>', 'Quit'},
    -- ['c'] = {'<cmd>Bdelete!<CR>', 'Close Buffer'},
    -- ['h'] = {'<cmd>nohlsearch<CR>', 'No Highlight'},
    -- ['f'] = {
    --     '<cmd>lua require(\'telescope.builtin\').find_files(require(\'telescope.themes\').get_dropdown{previewer = false})<CR>',
    --     'Find files',
    -- },
    -- ['F'] = {'<cmd>Telescope live_grep theme=ivy<CR>', 'Find Text'},
    -- ['P'] = {'<cmd>Telescope projects<CR>', 'Projects'},
    -- p = {
    --     name = 'Packer',
    --     c = {'<cmd>PackerCompile<CR>', 'Compile'},
    --     i = {'<cmd>PackerInstall<CR>', 'Install'},
    --     s = {'<cmd>PackerSync<CR>', 'Sync'},
    --     S = {'<cmd>PackerStatus<CR>', 'Status'},
    --     u = {'<cmd>PackerUpdate<CR>', 'Update'},
    -- },
    -- g = {
    --     name = 'Git',
    --     g = {'<cmd>lua _LAZYGIT_TOGGLE()<CR>', 'Lazygit'},
    --     j = {'<cmd>lua require \'gitsigns\'.next_hunk()<CR>', 'Next Hunk'},
    --     k = {'<cmd>lua require \'gitsigns\'.prev_hunk()<CR>', 'Prev Hunk'},
    --     l = {'<cmd>lua require \'gitsigns\'.blame_line()<CR>', 'Blame'},
    --     p = {'<cmd>lua require \'gitsigns\'.preview_hunk()<CR>', 'Preview Hunk'},
    --     r = {'<cmd>lua require \'gitsigns\'.reset_hunk()<CR>', 'Reset Hunk'},
    --     R = {'<cmd>lua require \'gitsigns\'.reset_buffer()<CR>', 'Reset Buffer'},
    --     s = {'<cmd>lua require \'gitsigns\'.stage_hunk()<CR>', 'Stage Hunk'},
    --     u = {
    --         '<cmd>lua require \'gitsigns\'.undo_stage_hunk()<CR>',
    --         'Undo Stage Hunk',
    --     },
    --     o = {'<cmd>Telescope git_status<CR>', 'Open changed file'},
    --     b = {'<cmd>Telescope git_branches<CR>', 'Checkout branch'},
    --     c = {'<cmd>Telescope git_commits<CR>', 'Checkout commit'},
    --     d = {'<cmd>Gitsigns diffthis HEAD<CR>', 'Diff'},
    -- },
    -- l = {
    --     name = 'LSP',
    --     a = {'<cmd>lua vim.lsp.buf.code_action()<CR>', 'Code Action'},
    --     d = {
    --         '<cmd>Telescope lsp_document_diagnostics<CR>',
    --         'Document Diagnostics',
    --     },
    --     w = {
    --         '<cmd>Telescope lsp_workspace_diagnostics<CR>',
    --         'Workspace Diagnostics',
    --     },
    --     f = {'<cmd>lua vim.lsp.buf.formatting()<CR>', 'Format'},
    --     i = {'<cmd>LspInfo<CR>', 'Info'},
    --     I = {'<cmd>LspInstallInfo<CR>', 'Installer Info'},
    --     j = {'<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', 'Next Diagnostic'},
    --     k = {'<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', 'Prev Diagnostic'},
    --     l = {'<cmd>lua vim.lsp.codelens.run()<CR>', 'CodeLens Action'},
    --     q = {'<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', 'Quickfix'},
    --     r = {'<cmd>lua vim.lsp.buf.rename()<CR>', 'Rename'},
    --     s = {'<cmd>Telescope lsp_document_symbols<CR>', 'Document Symbols'},
    --     S = {
    --         '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>',
    --         'Workspace Symbols',
    --     },
    -- },
    s = {
        name = 'Search',
        C = {'<cmd>Telescope commands<CR>', 'Commands'},
        M = {'<cmd>Telescope man_pages<CR>', 'Man Pages'},
        R = {'<cmd>Telescope registers<CR>', 'Registers'},
        b = {'<cmd>Telescope git_branches<CR>', 'Checkout branch'},
        c = {'<cmd>Telescope colorscheme<CR>', 'Colorscheme'},
        h = {'<cmd>Telescope help_tags<CR>', 'Find Help'},
        k = {'<cmd>Telescope keymaps<CR>', 'Keymaps'},
        l = {'<cmd>Telescope live_grep<CR>', 'Live grep'},
        r = {'<cmd>Telescope oldfiles<CR>', 'Open Recent File'},
    },
    -- t = {
    --     name = 'Terminal',
    --     n = {'<cmd>lua _NODE_TOGGLE()<CR>', 'Node'},
    --     u = {'<cmd>lua _NCDU_TOGGLE()<CR>', 'NCDU'},
    --     t = {'<cmd>lua _HTOP_TOGGLE()<CR>', 'Htop'},
    --     p = {'<cmd>lua _PYTHON_TOGGLE()<CR>', 'Python'},
    --     f = {'<cmd>ToggleTerm direction=float<CR>', 'Float'},
    --     h = {'<cmd>ToggleTerm size=10 direction=horizontal<CR>', 'Horizontal'},
    --     v = {'<cmd>ToggleTerm size=80 direction=vertical<CR>', 'Vertical'},
    -- },
    ['<leader>'] = {
        name = 'Setup',
        ['.'] = {':execute "lcd" dir#git_root()<CR>', 'cd to git-root'},
        h = {'<cmd>checkhealth<CR>', 'Health'},
        m = {':belowright 10split term://zsh<CR>', 'Open terminal'},
        v = {':tabedit <C-R>=VIM_CONFIG_FILE<CR><CR><CR>', 'init.vim'},
    },
}

local normal_mappings = {
    ['<F12>'] = {':call hl#show()<CR>', 'Show highlight info'},
    ['<leader>'] = {
        b = {
            name = 'fast buffers',
            ['0'] = {':blast<CR>', 'buffer: last'},
            ['1'] = {':bfirst<CR>', 'buffer: first'},
        },
        d = {'"_d', 'delete to a black hole'},
        x = {
            ':!xdg-open %<CR><CR>',
            'Open the current file in the default program',
        },
        ['<leader>'] = {t = {':tab split<CR>', 'tab: split'}},
        -- p = {'`[ . strpart(getregtype(), 0, 1) . `]', 'select latest pasted'},
    },
    N = {'Nzzzv', 'N and center'},
    ['<C-a>'] = {'gg<S-v>G', 'select all'},
    g = {
        name = 'fast buffers',
        h = {':bprevious<CR>', 'buffer: previous'},
        l = {':bnext<CR>', 'buffer: next'},
    },
    n = {'nzzzv', 'n and center'},
    t = {
        name = 'fast tabs',
        h = {':tabprevious<CR>', 'tab: previous'},
        l = {':tabnext<CR>', 'tab: next'},
        ['0'] = {':tablast<CR>', 'tab: last'},
        ['1'] = {':tabfirst<CR>', 'tab: first'},
        ['2'] = {':tabnext 2<CR>', 'tab: 2'},
    },
}

local norm_term_mappings = {
    ['<leader>'] = {
        ['\''] = {':belowright vsplit<CR>', 'vsplit right'},
        ['"'] = {':belowright split<CR>', 'split below'},
    },
}

local visual_mappings = {
    ['<leader>'] = {d = {'"_dd', 'delete to a black hole'}},
    ['<'] = {'<gv', 'don\'t loose selection when changing indentation'},
    ['>'] = {'>gv', 'don\'t loose selection when changing indentation'},
    g = {
        p = {'"_dP', 'paste replace visual selection without copying it'},
        P = {'"_dP', 'paste replace visual selection without copying it'},
    },
    Y = {'myY`y', 'Yank without jank'}, --- http://ddrscott.github.io/blog/2016/yank-without-jank
    y = {'myy`y', 'Yank without jank'},
}

local insert_mappings = {
    ['<C-a>'] = {'<Esc>I', 'Edit beginning of the line'},
    ['<C-e>'] = {'<Esc>A', 'Edit end of the line'},
}

which_key.setup(setup)
which_key.register(leader_mappings, leader_opts)
which_key.register(normal_mappings, normal_opts)
which_key.register(visual_mappings, visual_opts)
which_key.register(insert_mappings, insert_opts)
which_key.register(norm_term_mappings, normal_opts)
-- which_key.register(norm_term_mappings, terminal_opts)
