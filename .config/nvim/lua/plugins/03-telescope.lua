return {
    { -- https://github.com/nvim-telescope/telescope.nvim
        'nvim-telescope/telescope.nvim',
        config = function()
            local ok, plugin = pcall(require, 'telescope')
            if not ok then return end

            -- Enable telescope fzf native, if installed
            pcall(plugin.load_extension, 'fzf')

            local ta_ok, actions = pcall(require, 'telescope.actions')
            if not ta_ok then return end

            local config = {
                defaults = {
                    layout_config = {
                        height = 0.999,
                        preview_cutoff = 120,
                        prompt_position = 'top',
                        width = 0.999,
                    },
                    mappings = {
                        i = {
                            ['<C-n>'] = actions.cycle_history_next,
                            ['<C-p>'] = actions.cycle_history_prev,

                            ['<C-j>'] = actions.move_selection_next,
                            ['<C-k>'] = actions.move_selection_previous,

                            ['<C-c>'] = actions.close,

                            ['<Down>'] = actions.move_selection_next,
                            ['<Up>'] = actions.move_selection_previous,

                            ['<CR>'] = actions.select_default,
                            ['<C-x>'] = actions.select_horizontal,
                            ['<C-v>'] = actions.select_vertical,
                            ['<C-t>'] = actions.select_tab,

                            ['<C-u>'] = actions.preview_scrolling_up,
                            ['<C-d>'] = actions.preview_scrolling_down,

                            ['<PageUp>'] = actions.results_scrolling_up,
                            ['<PageDown>'] = actions.results_scrolling_down,

                            ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
                            ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
                            ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
                            ['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
                            ['<C-l>'] = actions.complete_tag,
                            ['<C-_>'] = actions.which_key, -- keys from pressing <C-/>
                        },

                        n = {
                            ['<esc>'] = actions.close,
                            ['<CR>'] = actions.select_default,
                            ['<C-x>'] = actions.select_horizontal,
                            ['<C-v>'] = actions.select_vertical,
                            ['<C-t>'] = actions.select_tab,

                            ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
                            ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
                            ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
                            ['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,

                            ['j'] = actions.move_selection_next,
                            ['k'] = actions.move_selection_previous,
                            ['H'] = actions.move_to_top,
                            ['M'] = actions.move_to_middle,
                            ['L'] = actions.move_to_bottom,

                            ['<Down>'] = actions.move_selection_next,
                            ['<Up>'] = actions.move_selection_previous,
                            ['gg'] = actions.move_to_top,
                            ['G'] = actions.move_to_bottom,

                            ['<C-u>'] = actions.preview_scrolling_up,
                            ['<C-d>'] = actions.preview_scrolling_down,

                            ['<PageUp>'] = actions.results_scrolling_up,
                            ['<PageDown>'] = actions.results_scrolling_down,

                            ['?'] = actions.which_key,
                        },
                    },
                    -- path_display = {'truncate'},
                    prompt_prefix = ': ',
                    scroll_strategy = 'limit',
                    selection_caret = ' ',
                    sorting_strategy = 'ascending',
                },
                pickers = {
                    -- Default configuration for builtin pickers goes here:
                    -- picker_name = {
                    --   picker_config_key = value,
                    --   ...
                    -- }
                    -- Now the picker_config_key will be applied every time you call this
                    -- builtin picker
                },
                extensions = {
                    -- Your extension configuration goes here:
                    -- extension_name = {
                    --   extension_config_key = value,
                    -- }
                    -- please take a look at the readme of the extension you want to configure
                    ['ui-select'] = {
                        -- require('telescope.themes').get_dropdown {
                        --     -- even more opts
                        -- },

                        -- pseudo code / specification for writing custom displays, like the one
                        -- for "codeactions"
                        -- specific_opts = {
                        --   [kind] = {
                        --     make_indexed = function(items) -> indexed_items, width,
                        --     make_displayer = function(widths) -> displayer
                        --     make_display = function(displayer) -> function(e)
                        --     make_ordinal = function(e) -> string
                        --   },
                        --   -- for example to disable the custom builtin "codeactions" display
                        --      do the following
                        --   codeactions = false,
                        -- }
                    },
                },
            }

            plugin.load_extension('ui-select')
            plugin.setup(config)

            local wk_ok, which_key = pcall(require, 'which-key')
            if wk_ok then
                which_key.add({
                    mode = {'n'},
                    nowait = true,
                    remap = false,
                    {'<leader>s', group = 'Search '},
                    {'<leader>s/', '<cmd>Telescope current_buffer_fuzzy_find<CR>', desc = ': sr'},
                    {'<leader>sB', '<cmd>Telescope builtin<CR>', desc = ': builtin'},
                    {'<leader>sC', '<cmd>Telescope colorscheme<CR>', desc = ': colorschemes'},
                    {'<leader>sH', '<cmd>Telescope highlights<CR>', desc = ': highlights'},
                    {'<leader>sM', '<cmd>Telescope marks<CR>', desc = ': marks'},
                    {'<leader>sR', '<cmd>Telescope registers<CR>', desc = ': registers'},
                    {'<leader>sa', '<cmd>Telescope autocommands<CR>', desc = ': autocommands'},
                    {'<leader>sb', '<cmd>Telescope buffers<CR>', desc = ': buffers'},
                    {'<leader>sc', '<cmd>Telescope commands<CR>', desc = ': commands'},
                    {'<leader>sd', '<cmd>Telescope diagnostics<CR>', desc = ': diagnostics'},
                    {'<leader>sf', '<cmd>Telescope oldfiles<CR>', desc = ': recent files'},
                    {'<leader>sg', '<cmd>Telescope live_grep<CR>', desc = ': live grep'},
                    {'<leader>sh', '<cmd>Telescope help_tags<CR>', desc = ': help'},
                    {'<leader>sj', '<cmd>Telescope jumplist<CR>', desc = ': jumplist'},
                    {'<leader>sk', '<cmd>Telescope keymaps<CR>', desc = ': keymaps'},
                    {'<leader>sm', '<cmd>Telescope man_pages<CR>', desc = ': man pages'},
                    {'<leader>sn', '<cmd>Telescope notify<CR>', desc = ': notifications'},
                    {'<leader>sp', '<cmd>Telescope find_files<CR>', desc = ': files'},
                    {'<leader>sr', '<cmd>Telescope resume<CR>', desc = ': resume previous'},
                    {'<leader>ss', '<cmd>Telescope search_history<CR>', desc = ': search hist'},
                    {'<leader>sv', '<cmd>Telescope vim_options<CR>', desc = ': vim options'},
                    {'<leader>sw', '<cmd>Telescope grep_string<CR>', desc = ': grep word'},
                    -- r = {
                    --     name = 'Repo (git)',
                    --     b = {'<cmd>Telescope git_branches<CR>', ': branches'},
                    --     c = {'<cmd>Telescope git_bcommits<CR>', ': commits for buffer'},
                    --     f = {'<cmd>Telescope git_files<CR>', ': files'},
                    --     l = {'<cmd>Telescope git_bcommits_range<CR>', ': commits curline'},
                    --     r = {'<cmd>Telescope git_commits<CR>', ': commits'},
                    --     s = {'<cmd>Telescope git_status<CR>', ': status'},
                    --     t = {'<cmd>Telescope git_stash<CR>', ': stashes'},
                    -- },
                })
                which_key.add({
                    mode = {'v'},
                    {'<leader>rl', '<cmd>Telescope git_bcommits_range<CR>', desc = 'cmt for lines'},

                    {'<leader>s', group = 'Search '},
                    {'<leader>sg', '<cmd>Telescope grep_string<CR>', desc = ': grep string'},
                })
            end
        end,
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- {
            --     'nvim-telescope/telescope-fzf-native.nvim',
            --     build = 'make',
            --     cond = function() return vim.fn.executable 'make' == 1 end,
            -- },
            'nvim-telescope/telescope-ui-select.nvim',
        },
    },
}
