return {
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/lambdalisue/suda.vim
        'lambdalisue/suda.vim',
        cmd = {'SudaRead', 'SudaWrite'},
    },
    { -- https://github.com/michaelb/sniprun
        'michaelb/sniprun',
        cmd = {'SnipRun', 'SnipInfo'},
        build = 'sh install.sh',
        config = function()
            require'sniprun'.setup {
                selected_interpreters = {}, -- # use those instead of the default for the current filetype
                repl_enable = {'Python3_original'},
                repl_disable = {}, -- # disable REPL-like behavior for the given interpreters

                interpreter_options = { -- # interpreter-specific options, see doc / :SnipInfo <name>
                    -- # use the interpreter name as key
                    GFM_original = {
                        use_on_filetypes = {'markdown.pandoc'}, -- # the 'use_on_filetypes' configuration key is
                        -- # available for every interpreter
                    },
                    Python3_original = {
                        error_truncate = 'auto', -- # Truncate runtime errors 'long', 'short' or 'auto'
                        -- # the hint is available for every interpreter
                        -- # but may not be always respected
                    },
                },

                -- # you can combo different display modes as desired and with the 'Ok' or 'Err' suffix
                -- # to filter only sucessful runs (or errored-out runs respectively)
                display = {
                    'TerminalWithCode',
                    'VirtualTextOk', -- # display ok results as virtual text (multiline is shortened)
                    'FloatingWinOk',

                    -- 'Classic',                 --# display results in the command-line  area
                    -- 'VirtualText',             --# display results as virtual text
                    -- 'TempFloatingWindow',      --# display results in a floating window
                    -- 'LongTempFloatingWindow',  --# same as above, but only long results. To use with VirtualText[Ok/Err]
                    -- 'Terminal',                --# display results in a vertical split
                    -- 'TerminalWithCode',        --# display results and code history in a vertical split
                    -- 'NvimNotify',              --# display with the nvim-notify plugin
                    -- 'Api'                      --# return output to a programming interface
                },

                live_display = {'VirtualTextOk'}, -- # display mode used in live_mode

                display_options = {
                    terminal_scrollback = vim.o.scrollback, -- # change terminal display scrollback lines
                    terminal_line_number = false, -- # whether show line number in terminal window
                    terminal_signcolumn = false, -- # whether show signcolumn in terminal window
                    terminal_persistence = true, -- # always keep the terminal open (true) or close it at every occasion (false)
                    terminal_width = 80, -- # change the terminal display option width
                    notification_timeout = 5, -- # timeout for nvim_notify output
                },

                -- # You can use the same keys to customize whether a sniprun producing
                -- # no output should display nothing or '(no output)'
                -- show_no_output = {
                --     'Classic',
                --     'TempFloatingWindow', -- # implies LongTempFloatingWindow, which has no effect on its own
                -- },

                -- # customize highlight groups (setting this overrides colorscheme)
                snipruncolors = {
                    SniprunVirtualTextOk = {
                        bg = '#66eeff',
                        fg = '#000000',
                        ctermbg = 'Cyan',
                        cterfg = 'Black',
                    },
                    SniprunFloatingWinOk = {fg = '#66eeff', ctermfg = 'Cyan'},
                    SniprunVirtualTextErr = {
                        bg = '#881515',
                        fg = '#000000',
                        ctermbg = 'DarkRed',
                        cterfg = 'Black',
                    },
                    SniprunFloatingWinErr = {fg = '#881515', ctermfg = 'DarkRed'},
                },

                live_mode_toggle = 'off', -- # live mode toggle, see Usage - Running for more info

                -- # miscellaneous compatibility/adjustement settings
                inline_messages = false, -- # boolean toggle for a one-line way to display messages
                -- # to workaround sniprun not being able to display anything

                borders = 'single', -- # display borders around floating windows
                -- # possible values are 'none', 'single', 'double', or 'shadow'
            }
        end,
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/dstein64/vim-startuptime
        'dstein64/vim-startuptime',
        cmd = 'StartupTime', -- lazy-load on a command
        init = function() -- init is called during startup. Configuration for vim plugins typically should be set in an init function
            vim.g.startuptime_tries = 10
        end,
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- url: https://github.com/rest-nvim/rest.nvim
        'rest-nvim/rest.nvim',
        ft = {'http'},
        config = function()
            local plugin = require('rest-nvim')
            plugin.setup {
                -- Open request results in a horizontal split
                result_split_horizontal = false,
                -- Keep the http file buffer above|left when split horizontal|vertical
                result_split_in_place = false,
                -- Skip SSL verification, useful for unknown certificates
                skip_ssl_verification = false,
                -- Encode URL before making request
                encode_url = true,
                -- Highlight request on run
                highlight = {enabled = true, timeout = 150},
                result = {
                    -- toggle showing URL, HTTP info, headers at top the of result window
                    show_url = true,
                    -- show the generated curl command in case you want to launch
                    -- the same request via the terminal (can be verbose)
                    show_curl_command = true,
                    show_http_info = true,
                    show_headers = true,
                    -- executables or functions for formatting response body [optional]
                    -- set them to false if you want to disable them
                    formatters = {
                        json = 'jq',
                        html = function(body)
                            return vim.fn.system({'tidy', '-i', '-q', '-'}, body)
                        end,
                    },
                },
                -- Jump to request line on run
                jump_to_request = true,
                env_file = '.env',
                custom_dynamic_variables = {},
                yank_dry_run = true,
            }

            local wk_ok, which_key = pcall(require, 'which-key')
            if wk_ok then
                local normal_mappings = {['<F5>'] = {plugin.run, 'rest: run'}}

                which_key.register(normal_mappings, {mode = 'n', nowait = true, noremap = true})
            end
        end,
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- url: https://github.com/diepm/vim-rest-console
        'diepm/vim-rest-console',
        enabled = false,
        config = function()
            vim.g.vrc_set_default_mapping = false
            -- vim.g.vrc_show_command = true
            vim.g.vrc_auto_format_uhex = true
            vim.g.vrc_auto_format_response_patterns = {json = 'jq -S', xml = 'tidy -xml -i -'}

            vim.cmd [[

augroup PluginVimRestConsole
	autocmd!
	autocmd FileType rest       nnoremap <F5> :call VrcQuery()<CR>
augroup END

]]

        end,
    },
}
