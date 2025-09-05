return {
    { -- https://github.com/neovim/nvim-lspconfig
        'neovim/nvim-lspconfig',
        config = function()
            -- vim.lsp.set_log_level('debug')

            -- => default commands -------------------------------------------------------------------------------- {{{1

            -- vim.cmd [[ command! LspFormat execute 'lua vim.lsp.buf.formatting()' ]]

            -- => default keybindings ----------------------------------------------------------------------------- {{{1

            -- vim.notify('init lsp', 'INFO')
            vim.lsp.config('denols', {filetypes = {'deno', 'typescript.deno'}})

            local wk_ok, which_key = pcall(require, 'which-key')
            if not wk_ok then return end

            -- h: lsp-buf

            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {clear = true}),
                callback = function(ev)
                    -- Enable completion triggered by <c-x><c-o>
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    -- See `:help vim.lsp.*` for documentation on any of the below functions
                    which_key.add({
                        noremap = true,
                        {'<leader>l', group = 'LSP'},
                        {'<leader>li', '<cmd>LspInfo<CR>', desc = 'Info'},
                        {'<leader>ll', '<cmd>Telescope lsp_document_symbols<CR>', desc = 'symbols'},

                        {'<leader>lc', group = 'calls'},
                        {'<leader>lci', '<cmd>Telescope lsp_incoming_calls<CR>', desc = 'incoming'},
                        {'<leader>lco', '<cmd>Telescope lsp_outgoing_calls<CR>', desc = 'outgoing'},

                        {'<leader>ls', group = 'symbols'},
                        {
                            '<leader>lsd',
                            '<cmd>Telescope lsp_document_symbols<CR>',
                            desc = 'document',
                        },
                        {
                            '<leader>lsw',
                            '<cmd>Telescope lsp_workspace_symbols<CR>',
                            desc = 'workspace',
                        },
                        {
                            '<leader>lsy',
                            '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>',
                            desc = 'dynamic workspace',
                        },

                        {'gD', '<cmd>FzfLua lsp_declarations<CR>', desc = 'goto: declaration'},
                        -- I = {vim.lsp.buf.implementation, 'goto: implementation'},
                        {'gI', '<cmd>FzfLua lsp_implementations<CR>', desc = 'goto: implementation'},
                        -- d = {vim.lsp.buf.definition, 'goto: definition'},
                        {'gd', '<cmd>FzfLua lsp_definitions<CR>', desc = 'goto: definition'},
                        -- r = {vim.lsp.buf.references, 'goto: references'},
                        {'gr', '<cmd>FzfLua lsp_references<CR>', desc = 'goto: references'},
                        -- y = {vim.lsp.buf.type_definition, 'goto: type definition'},
                        {'gy', '<cmd>FzfLua lsp_typedefs<CR>', desc = 'goto: type definition'},
                    }, {bufer = ev.buf})
                end,
            })
        end,
        dependencies = {
            -- { -- https://github.com/j-hui/fidget.nvim
            --     'j-hui/fidget.nvim',
            --     tag = 'legacy',
            --     opts = {},
            -- },
            { -- https://github.com/folke/neoconf.nvim
                'folke/neoconf.nvim',
                opts = {},
            },
            { -- https://github.com/folke/neodev.nvim
                'folke/neodev.nvim',
                opts = {},
            },
            { -- https://github.com/williamboman/mason-lspconfig.nvim
                'williamboman/mason-lspconfig.nvim',
                dependencies = {'williamboman/mason.nvim'},
                config = function()
                    local ensure_installed = T {'bashls', 'jsonls', 'perlnavigator', 'yamlls'}

                    -- local function on_attach(data, bufnr)
                    --     -- data.config.capabilities = nil
                    --     -- print('attached', vim.inspect(data.config))
                    --     if data.config.set_on_attach then data.config.set_on_attach(data, bufnr) end
                    -- end

                    -- -- LSP settings (for overriding per client)
                    -- local lsp_handlers = {
                    --     ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
                    --         border = 'rounded',
                    --     }),
                    --     ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help,
                    --         {border = 'rounded'}),
                    -- }

                    local plugin = require('mason-lspconfig')
                    plugin.setup {
                        ensure_installed = ensure_installed,
                        -- handlers = {
                        --     function(server_name)
                        --         local opts = {on_attach = on_attach, handlers = lsp_handlers}
                        --         local lsp_set_ok, settings = pcall(require,
                        --             string.format('lsp.settings-%s', server_name))
                        --         if lsp_set_ok then
                        --             if settings.set_prepare then
                        --                 settings.set_prepare(server_name, settings)
                        --             end
                        --             opts = vim.tbl_deep_extend('force', settings, opts)
                        --         end

                        --         -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
                        --         require('lspconfig')[server_name].setup(opts)
                        --     end,
                        -- },
                    }
                end,
            },
        },
        event = {'BufReadPost', 'BufNewFile'},
    },
    { -- https://github.com/ray-x/lsp_signature.nvim
        'ray-x/lsp_signature.nvim',
        event = {'BufReadPost', 'BufNewFile'},
        opts = {
            debug = false, -- set to true to enable debug logging
            -- log_path = 'debug_log_file_path', -- debug log path
            verbose = false, -- show debug line number
            bind = true, -- This is mandatory, otherwise border config won't get registered.
            -- If you want to hook lspsaga or other signature handler, pls set to false
            doc_lines = 10, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
            -- set to 0 if you DO NOT want any API comments be shown
            -- This setting only take effect in insert mode, it does not affect signature help in normal
            -- mode, 10 by default
            wrap = true, -- allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too long
            floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
            floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
            -- will set to true when fully tested, set to false will use whichever side has more space
            -- this setting will be helpful if you do not want the PUM and floating win overlap
            fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
            hint_enable = true, -- virtual hint enable
            hint_prefix = '🐼 ', -- Panda for parameter
            hint_scheme = 'String',
            hi_parameter = 'LspSignatureActiveParameter', -- how your parameter will be highlight
            -- max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
            -- to view the hiding contents
            max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
            handler_opts = {
                border = 'rounded', -- double, rounded, single, shadow, none
            },
            always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58
            auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
            check_completion_visible = true, -- adjust position of signature window relative to completion popup
            extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
            move_cursor_key = nil, -- imap, use nvim_set_current_win to move cursor between current win and floating
            padding = '', -- character to pad on left and right of signature can be ' ', or '|'  etc
            select_signature_key = nil, -- cycle to next signature, e.g. '<M-n>' function overloading
            shadow_blend = 36, -- if you using shadow as border use this set the opacity
            shadow_guibg = 'Black', -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
            timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
            toggle_key = nil, -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
            transparency = nil, -- disabled by default, allow floating win transparent value 1~100
            zindex = 200, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom
        },
    },
}
