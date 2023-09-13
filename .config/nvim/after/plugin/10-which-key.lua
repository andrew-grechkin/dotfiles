-- url: https://github.com/folke/which-key.nvim
local ok, which_key = pcall(require, 'which-key')
if not ok then return end

local setup = {
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
    operators = {},
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

-- => ------------------------------------------------------------------------------------------------------------- {{{1

local normal_opts = {nowait = true}
local insert_opts = {mode = 'i', nowait = true}
local visual_opts = {mode = 'v', nowait = true}
-- local terminal_opts = {mode = 't', nowait = true}

local normal_mappings = {
    ['<leader>'] = {
        -- ['b'] = {
        --     '<cmd>lua require(\'telescope.builtin\').buffers(require(\'telescope.themes\').get_dropdown{previewer = false})<CR>',
        --     'Buffers',
        -- },
        -- ['c'] = {'<cmd>Bdelete!<CR>', 'Close Buffer'},
        -- ['h'] = {'<cmd>nohlsearch<CR>', 'No Highlight'},
        -- ['f'] = {
        --     '<cmd>lua require(\'telescope.builtin\').find_files(require(\'telescope.themes\').get_dropdown{previewer = false})<CR>',
        --     'Find files',
        -- },
        -- ['F'] = {'<cmd>Telescope live_grep theme=ivy<CR>', 'Find Text'},
        -- p = {
        --     name = 'Packer',
        --     c = {'<cmd>PackerCompile<CR>', 'Compile'},
        --     i = {'<cmd>PackerInstall<CR>', 'Install'},
        --     s = {'<cmd>PackerSync<CR>', 'Sync'},
        --     S = {'<cmd>PackerStatus<CR>', 'Status'},
        --     u = {'<cmd>PackerUpdate<CR>', 'Update'},
        -- },
        ['<CR>'] = {'!!bash<CR>', 'execute line in shell'},
        ['<leader>'] = {
            name = 'Setup',
            ['.'] = {':execute "lcd" dir#git_root()<CR>', 'cd to git-root'},
            ['h'] = {'<cmd>checkhealth<CR>', 'Health'},
            ['m'] = {':belowright 10split term://zsh<CR>', 'open terminal'},
            ['t'] = {':tab split<CR>', 'tab: split'},
            ['v'] = {':tabedit <C-R>=VIM_CONFIG_FILE<CR><CR><CR>', 'init.vim'},
        },
        b = {
            name = 'Fast buffers',
            ['0'] = {':blast<CR>', 'buffer: last'},
            ['1'] = {':bfirst<CR>', 'buffer: first'},
        },
        -- d = {'"_d', 'delete to a black hole'},
        -- p = {'`[ . strpart(getregtype(), 0, 1) . `]', 'Select latest pasted'},
        r = {
            name = 'Repo (git)',
            b = {'<cmd>Telescope git_branches<CR>', 'branches'},
            c = {'<cmd>Telescope git_bcommits<CR>', 'commits for buffer'},
            f = {'<cmd>Telescope git_files<CR>', 'files'},
            l = {'<cmd>Telescope git_bcommits_range<CR>', 'commits for current line'},
            o = {'<cmd>Telescope git_status<CR>', 'status'},
            r = {'<cmd>Telescope git_commits<CR>', 'commits'},
            s = {'<cmd>Telescope git_stash<CR>', 'stashes'},
            --     g = {'<cmd>lua _LAZYGIT_TOGGLE()<CR>', 'Lazygit'},
            --     R = {'<cmd>lua require \'gitsigns\'.reset_buffer()<CR>', 'Reset Buffer'},
        },
        s = {
            name = 'Search',
            C = {'<cmd>Telescope colorscheme<CR>', 'colorschemes'},
            R = {'<cmd>Telescope registers<CR>', 'registers'},
            c = {'<cmd>Telescope commands<CR>', 'commands'},
            g = {'<cmd>Telescope live_grep<CR>', 'live grep'},
            h = {'<cmd>Telescope help_tags<CR>', 'help'},
            k = {'<cmd>Telescope keymaps<CR>', 'keymaps'},
            m = {'<cmd>Telescope man_pages<CR>', 'man pages'},
            r = {'<cmd>Telescope oldfiles<CR>', 'recent files'},
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
        x = {':!xdg-open %<CR><CR>', 'Open in the default program'},
    },
    ['<A-\\>'] = {'<Esc>:TmuxNavigatePrevious<CR>', 'tmux: navigate previous'},
    ['<A-h>'] = {'<Esc>:TmuxNavigateLeft<CR>', 'tmux: navigate left'},
    ['<A-j>'] = {'<Esc>:TmuxNavigateDown<CR>', 'tmux: navigate down'},
    ['<A-k>'] = {'<Esc>:TmuxNavigateUp<CR>', 'tmux: navigate up'},
    ['<A-l>'] = {'<Esc>:TmuxNavigateRight<CR>', 'tmux: navigate right'},
    ['<C-a>'] = {'gg<S-v>G', 'select all'},
    ['<C-d>'] = {'<C-d>zz', 'scroll down and centralize'},
    ['<C-u>'] = {'<C-u>zz', 'scroll up and centralize'},
    ['<F12>'] = {':call hl#show()<CR>', 'show highlight info'},
    g = {
        name = 'fast buffers',
        h = {':bprevious<CR>', 'buffer: previous'},
        l = {':bnext<CR>', 'buffer: next'},
    },
    N = {'Nzzzv', 'N and centralize'},
    n = {'nzzzv', 'n and centralize'},
    t = {
        name = 'fast tabs',
        ['0'] = {':tablast<CR>', 'tab: last'},
        ['1'] = {':tabfirst<CR>', 'tab: first'},
        ['2'] = {':tabnext 2<CR>', 'tab: 2'},
        h = {':tabprevious<CR>', 'tab: previous'},
        l = {':tabnext<CR>', 'tab: next'},
    },
}

local visual_mappings = {
    ['<leader>'] = {
        ['<CR>'] = {':!bash<CR>', 'execute lines in shell'},
        -- d = {'"_dd', 'delete to a black hole'},
        r = {
            name = 'Repo (git)',
            l = {'<cmd>Telescope git_bcommits_range<CR>', 'commits for selected lines'},
        },
    },
    ['<'] = {'<gv', 'don\'t loose selection when changing indentation'},
    ['>'] = {'>gv', 'don\'t loose selection when changing indentation'},
    g = {
        p = {'"_dp', 'paste replace visual selection without copying it'},
        P = {'"_dP', 'paste replace visual selection without copying it'},
    },
    Y = {'myY`y', 'Yank without jank'}, -- http://ddrscott.github.io/blog/2016/yank-without-jank
    y = {'myy`y', 'Yank without jank'},
}

local insert_mappings = {
    ['<C-a>'] = {'<Esc>I', 'edit beginning of the line'},
    ['<C-e>'] = {'<Esc>A', 'edit end of the line'},
    ['<A-\\>'] = {'<Esc>:TmuxNavigatePrevious<CR>', 'tmux: navigate previous'},
    ['<A-h>'] = {'<Esc>:TmuxNavigateLeft<CR>', 'tmux: navigate left'},
    ['<A-j>'] = {'<Esc>:TmuxNavigateDown<CR>', 'tmux: navigate down'},
    ['<A-k>'] = {'<Esc>:TmuxNavigateUp<CR>', 'tmux: navigate up'},
    ['<A-l>'] = {'<Esc>:TmuxNavigateRight<CR>', 'tmux: navigate right'},
}

local norm_term_mappings = {
    ['<leader>'] = {
        ['\''] = {':belowright vsplit<CR>', 'vsplit right'},
        ['"'] = {':belowright split<CR>', 'split below'},
    },
}

which_key.setup(setup)
which_key.register(normal_mappings, normal_opts)
which_key.register(visual_mappings, visual_opts)
which_key.register(insert_mappings, insert_opts)
which_key.register(norm_term_mappings, normal_opts)
-- which_key.register(norm_term_mappings, terminal_opts)
