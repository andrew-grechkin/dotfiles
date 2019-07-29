return {
    { -- url: https://github.com/andrew-grechkin/rest.nvim
        'andrew-grechkin/rest.nvim',
        -- dev = true,
        ft = {'http'},
        config = function()
            local plugin = require('rest-nvim')
            local dynamic_variable_from_command = function(name, command)
                if vim.env[name] then return vim.env[name] end

                local handle = io.popen(command)
                if handle then
                    local output = handle:read('*a')
                    handle:close()

                    vim.env[name] = string.gsub(output, '^%s*(.-)%s*$', '%1')
                    return vim.env[name]
                end

                return os.getenv(name)
            end
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
                highlight = {enabled = true, timeout = 250},
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
                        html = function(body)
                            if vim.fn.executable('tidy') == 0 then return body end
                            -- stylua: ignore
                            return vim.fn.system({
                                'tidy',
                                '-i',
                                '-q',
                                '--tidy-mark',
                                'no',
                                '--show-body-only',
                                'auto',
                                '--show-errors',
                                '0',
                                '--show-warnings',
                                '0',
                                '-',
                            }, body):gsub('\n$', '')
                        end,
                        json = function(body)
                            if vim.fn.executable('jq') == 0 then return body end
                            return vim.fn.system({'jq', '-S'}, body):gsub('\n$', '')
                        end,
                    },
                },
                -- Jump to request line on run
                jump_to_request = true,
                env_file = '.env',
                yank_dry_run = true,
                custom_dynamic_variables = {
                    ['DQS_ACCESS_TOKEN'] = function()
                        return dynamic_variable_from_command('DQS_ACCESS_TOKEN', 'authxagent-issue-access-token')
                    end,
                    ['DQS_S2S_TOKEN'] = function()
                        return dynamic_variable_from_command('DQS_S2S_TOKEN', 'authxagent-issue-s2s-token')
                    end,
                    ['PROD_ACCESS_TOKEN'] = function()
                        return dynamic_variable_from_command('PROD_ACCESS_TOKEN', 'authxagent-issue-access-token-prod')
                    end,
                    ['PROD_S2S_TOKEN'] = function()
                        return dynamic_variable_from_command('PROD_S2S_TOKEN', 'authxagent-issue-s2s-token-token-prod')
                    end,
                    ['NOW'] = function()
                        return dynamic_variable_from_command('NOW', 'date --iso-8601=seconds')
                    end,
                    ['PERSONAL_DQS_TOKEN'] = function() -- deprecated
                        return dynamic_variable_from_command('PERSONAL_DQS_TOKEN', 'authxagent-issue-access-token')
                    end,
                },
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
