return {
    { -- https://github.com/ibhagwan/fzf-lua
        'ibhagwan/fzf-lua',
        config = function()
            local plugin = require('fzf-lua')
            plugin.setup({
                git = {commits = {cmd = 'git l'}, bcommits = {cmd = 'git l -- {file}'}},
                winopts = {
                    fullscreen = true,
                    preview = {layout = 'vertical', vertical = 'down:40%'},
                },
            })
            plugin.register_ui_select()

            vim.api.nvim_create_user_command('Ft', function() require('fzf-lua').filetypes() end, {})
        end,
        dependencies = {
            { -- url: https://github.com/junegunn/fzf
                'junegunn/fzf',
                build = './install --bin',
            },
            'nvim-tree/nvim-web-devicons',
            'folke/which-key.nvim',
        },
        init = function() require('which-key').add({{'<leader>r', group = 'Repo (git+fzf)'}}) end,
        keys = {
            {'<C-b>', '<cmd>FzfLua buffers<CR>', mode = {'n'}, desc = 'fzf: buffers'},
            {'<C-h>', '<cmd>FzfLua oldfiles<CR>', mode = {'n'}, desc = 'fzf: history'},
            {
                '<C-p>',
                function()
                    local dir = PROJECT_GIT_ROOT_OR_CWD()
                    require('fzf-lua').files({cwd = dir})
                end,
                mode = {'n'},
                desc = 'fzf: files project',
            },
            {
                '<leader><C-p>',
                function()
                    local dir = vim.fs.dirname(vim.fn.expand('%'))
                    require('fzf-lua').files({cwd = dir})
                end,
                mode = {'n'},
                desc = 'fzf: files curdir',
            },
            {'<leader>rb', '<cmd>FzfLua git_branches<CR>', mode = {'n'}, desc = 'fzf: branches'},
            {
                '<leader>rc',
                '<cmd>FzfLua git_bcommits<CR>',
                mode = {'n'},
                desc = 'fzf: commits for buffer',
            },
            {'<leader>rS', '<cmd>FzfLua git_stash<CR>', mode = {'n'}, desc = 'fzf: stashes'},
            {'<leader>rf', '<cmd>FzfLua git_files<CR>', mode = {'n'}, desc = 'fzf: files'},
            {'<leader>rr', '<cmd>FzfLua git_commits<CR>', mode = {'n'}, desc = 'fzf: commits'},
            {'<leader>rs', '<cmd>FzfLua git_status<CR>', mode = {'n'}, desc = 'fzf: status'},
            {'<leader>rt', '<cmd>FzfLua git_tags<CR>', mode = {'n'}, desc = 'fzf: tags'},
            {
                '<leader><leader>o',
                '<cmd>FzfLua nvim_options<CR>',
                mode = {'n'},
                desc = 'fzf: nvim options',
            },
        },
        lazy = false,
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/ThePrimeagen/harpoon
        'ThePrimeagen/harpoon',
        config = function()
            local plugin = require('harpoon')
            local config = {
                -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
                save_on_toggle = false,

                -- saves the harpoon file upon every change. disabling is unrecommended.
                save_on_change = true,

                -- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
                enter_on_sendcmd = false,

                -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
                tmux_autoclose_windows = false,

                -- filetypes that you want to prevent from adding to the harpoon list menu.
                excluded_filetypes = {'harpoon'},

                -- set marks specific to each git branch inside git repository
                mark_branch = false,

                -- enable tabline with harpoon marks
                tabline = false,
                tabline_prefix = '   ',
                tabline_suffix = '   ',
            }
            plugin.setup(config)
            require('telescope').load_extension('harpoon')
        end,
        dependencies = {'nvim-telescope/telescope.nvim'},
        keys = {
            {
                'z<Space>',
                function() require('harpoon.mark').add_file() end,
                mode = {'n'},
                desc = 'harpoon: add',
            },
            {
                'z,',
                function() require('harpoon.ui').nav_prev() end,
                mode = {'n'},
                desc = 'harpoon: prev',
            },
            {
                'z.',
                function() require('harpoon.ui').nav_next() end,
                mode = {'n'},
                desc = 'harpoon: next',
            },
            {
                'zh',
                function() require('harpoon.ui').toggle_quick_menu() end,
                mode = {'n'},
                desc = 'harpoon: menu',
            },
            {
                'zj',
                function() require('harpoon.ui').nav_file(1) end,
                mode = {'n'},
                desc = 'harpoon: 1',
            },
            {
                'zk',
                function() require('harpoon.ui').nav_file(2) end,
                mode = {'n'},
                desc = 'harpoon: 2',
            },
            {
                'zl',
                function() require('harpoon.ui').nav_file(3) end,
                mode = {'n'},
                desc = 'harpoon: 3',
            },
            {
                'z;',
                function() require('harpoon.ui').nav_file(4) end,
                mode = {'n'},
                desc = 'harpoon: 4',
            },
        },
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/vifm/vifm.vim
        'vifm/vifm.vim',
        cmd = {'EditVifm'},
        config = function() vim.g.vifm_embed_split = 1 end,
        dependencies = {'folke/which-key.nvim'},
        keys = {
            {
                '<leader><leader>n',
                ':EditVifm<CR>',
                mode = {'n'},
                desc = 'vifm: open',
                nowait = true,
                noremap = true,
            },
        },
        lazy = false,
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/christoomey/vim-tmux-navigator
        'christoomey/vim-tmux-navigator',
        config = function()
            local wk_ok, which_key = pcall(require, 'which-key')
            if wk_ok then
                which_key.add({
                    mode = {'n', 'i', 't'},
                    nowait = true,
                    remap = false,
                    {'<M-\\>', '<C-\\><C-n>:TmuxNavigatePrevious<CR>', desc = 'tmux: navigate prev'},
                    {'<M-h>', '<C-\\><C-n>:TmuxNavigateLeft<CR>', desc = 'tmux: navigate left'},
                    {'<M-j>', '<C-\\><C-n>:TmuxNavigateDown<CR>', desc = 'tmux: navigate down'},
                    {'<M-k>', '<C-\\><C-n>:TmuxNavigateUp<CR>', desc = 'tmux: navigate up'},
                    {'<M-l>', '<C-\\><C-n>:TmuxNavigateRight<CR>', desc = 'tmux: navigate right'},
                })
            end
        end,
        dependencies = {'folke/which-key.nvim'},
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/mbbill/undotree
        'mbbill/undotree',
        cmd = {'UndotreeToggle'},
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/nacro90/numb.nvim
        'nacro90/numb.nvim',
        event = {'BufReadPost', 'BufNewFile'},
        opts = {},
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/miteshP/nvim-navbuddy
        'SmiteshP/nvim-navbuddy',
        cmd = {'Navbuddy'},
        dependencies = {'SmiteshP/nvim-navic', 'MunifTanjim/nui.nvim'},
        opts = {
            window = {
                border = 'single', -- "rounded", "double", "solid", "none"
                -- or an array with eight chars building up the border in a clockwise fashion
                -- starting with the top-left corner. eg: { "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" }.
                size = '90%', -- Or table format example: { height = "40%", width = "100%"}
                position = '50%', -- Or table format example: { row = "100%", col = "0%"}
                scrolloff = 2, -- scrolloff value within navbuddy window
                sections = {
                    left = {
                        size = '20%',
                        border = nil, -- You can set border style for each section individually as well.
                    },
                    mid = {size = '40%', border = nil},
                    right = {
                        preview = 'always', -- Right section can show previews too. Options: "leaf", "always" or "never"
                    },
                },
            },
            lsp = {auto_attach = true},
        },
    },
}
