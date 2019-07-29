return {
    { -- https://github.com/akinsho/bufferline.nvim
        'akinsho/bufferline.nvim',
        event = {'BufReadPost', 'BufNewFile'},
        -- keys = {
        --     {'<leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Toggle pin'},
        --     {
        --         '<leader>bP',
        --         '<Cmd>BufferLineGroupClose ungrouped<CR>',
        --         desc = 'Delete non-pinned buffers',
        --     },
        -- },
        opts = {
            options = {
                -- diagnostics_indicator = function(_, _, diag)
                --     local icons = require('lazyvim.config').icons.diagnostics
                --     local ret = (diag.error and icons.Error .. diag.error .. ' ' or '') ..
                --                     (diag.warning and icons.Warn .. diag.warning or '')
                --     return vim.trim(ret)
                -- end,
                offsets = {
                    {
                        filetype = 'neo-tree',
                        highlight = 'Directory',
                        text = 'Neo-tree',
                        text_align = 'left',
                    },
                },
                always_show_bufferline = false,
                color_icons = true, -- whether or not to add the filetype icon highlights
                diagnostics = 'nvim_lsp',
                indicator = {icon = '>', style = 'icon'},
                left_mouse_command = 'buffer %d', -- can be a string | function, | false see "Mouse actions"
                middle_mouse_command = 'bdelete! %d', -- can be a string | function, | false see "Mouse actions"
                modified_icon = '+',
                numbers = 'buffer_id',
                persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
                right_mouse_command = nil, -- can be a string | function | false, see "Mouse actions"
                separator_style = {'', ''},
                show_buffer_close_icons = false,
                show_buffer_icons = true, -- disable filetype icons for buffers
                sort_by = 'id',
            },
        },
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/nvim-lualine/lualine.nvim
        'nvim-lualine/lualine.nvim',
        config = function()
            local ok, plugin = pcall(require, 'lualine')
            if not ok then return end

            local section_c = {
                {
                    'filename',
                    file_status = true, -- Displays file status (readonly status, modified status)
                    newfile_status = false, -- Display new file status (new file means no write after created)
                    path = 3, -- 0: Just the filename
                    -- 1: Relative path
                    -- 2: Absolute path
                    -- 3: Absolute path, with tilde as the home directory
                    -- 4: Filename and parent dir, with tilde as the home directory

                    shorting_target = 40, -- Shortens path to leave 40 spaces in the window
                    -- for other components. (terrible name, any suggestions?)
                    symbols = {
                        modified = '[+]', -- Text to show when the file is modified.
                        readonly = '[!]', -- Text to show when the file is non-modifiable or readonly.
                        unnamed = '[No Name]', -- Text to show for unnamed buffers.
                        newfile = '[New]', -- Text to show for newly created file before first write
                    },
                },
            }

            local config = {
                options = {
                    always_divide_middle = true,
                    component_separators = {left = '', right = ''},
                    disabled_filetypes = {statusline = {}, winbar = {}},
                    globalstatus = false,
                    icons_enabled = true,
                    ignore_focus = {},
                    refresh = {statusline = 1000, tabline = 1000, winbar = 1000},
                    section_separators = {left = '', right = ''},
                    theme = 'luna',
                },
                sections = {
                    lualine_a = {'mode'},
                    lualine_b = {'branch', 'diff', 'diagnostics'},
                    lualine_c = section_c,
                    lualine_x = {'encoding', 'fileformat', 'filetype'},
                    lualine_y = {'progress', 'filesize'},
                    lualine_z = {'searchcount', 'location'},
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = section_c,
                    lualine_x = {'encoding', 'fileformat', 'filetype'},
                    lualine_y = {'progress', 'filesize'},
                    lualine_z = {'searchcount', 'location'},
                },
                extensions = {'quickfix'},
                inactive_winbar = {},
                tabline = {},
                winbar = {},
            }

            plugin.setup(config)
        end,
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/nvim-tree/nvim-web-devicons
        'nvim-tree/nvim-web-devicons',
        lazy = true,
    }, -- ui components
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/MunifTanjim/nui.nvim
        'MunifTanjim/nui.nvim',
        lazy = true,
    },
    -- -- noicer ui
    -- { -- https://github.com/
    --     'folke/which-key.nvim',
    --     -- opts = function(_, opts)
    --     --     if require('lazyvim.util').has('noice.nvim') then opts.defaults['<leader>sn'] = {
    --     --         name = '+noice',
    --     --     } end
    --     -- end,
    -- },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    -- { -- https://github.com/folke/noice.nvim
    --     'folke/noice.nvim',
    --     event = 'VeryLazy',
    --     opts = {
    --         -- -- lsp = {
    --         -- --     override = {
    --         -- --         ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
    --         -- --         ['vim.lsp.util.stylize_markdown'] = true,
    --         -- --         ['cmp.entry.get_documentation'] = true,
    --         -- --     },
    --         -- -- },
    --         -- routes = {
    --         --     {
    --         --         filter = {
    --         --             event = 'msg_show',
    --         --             any = {
    --         --                 {find = '%d+L, %d+B'}, {find = '; after #%d+'},
    --         --                 {find = '; before #%d+'},
    --         --             },
    --         --         },
    --         --         view = 'mini',
    --         --     },
    --         -- },
    --         -- presets = {
    --         --     bottom_search = true,
    --         --     command_palette = true,
    --         --     long_message_to_split = true,
    --         --     inc_rename = true,
    --         -- },
    --     },
    --     -- stylua: ignore
    --     keys = {
    --         -- {
    --         --     '<S-Enter>',
    --         --     function() require('noice').redirect(vim.fn.getcmdline()) end,
    --         --     mode = 'c',
    --         --     desc = 'Redirect Cmdline',
    --         -- },
    --         -- {
    --         --     '<leader>snl',
    --         --     function() require('noice').cmd('last') end,
    --         --     desc = 'Noice Last Message',
    --         -- },
    --         -- {'<leader>snh', function() require('noice').cmd('history') end, desc = 'Noice History'},
    --         -- {'<leader>sna', function() require('noice').cmd('all') end, desc = 'Noice All'},
    --         -- {'<leader>snd', function() require('noice').cmd('dismiss') end, desc = 'Dismiss All'},
    --         -- {
    --         --     '<c-f>',
    --         --     function() if not require('noice.lsp').scroll(4) then return '<c-f>' end end,
    --         --     silent = true,
    --         --     expr = true,
    --         --     desc = 'Scroll forward',
    --         --     mode = {'i', 'n', 's'},
    --         -- }, {
    --         --     '<c-b>',
    --         --     function() if not require('noice.lsp').scroll(-4) then return '<c-b>' end end,
    --         --     silent = true,
    --         --     expr = true,
    --         --     desc = 'Scroll backward',
    --         --     mode = {'i', 'n', 's'},
    --         -- },
    --     },
    -- },
}
