return {
    { -- https://github.com/sourcegraph/sg.nvim
        'sourcegraph/sg.nvim',
        enabled = not (vim.version().major < 1 and vim.version().minor < 9),
        dependencies = {'nvim-lua/plenary.nvim'},
        keys = {
            'n',
            {
                '<leader><leader>c',
                function()
                    local chat = require('sg.cody.rpc.chat')

                    local last_chat = chat.get_last_chat()
                    if last_chat then
                        if vim.api.nvim_win_is_valid(last_chat.windows.history_win) then
                            last_chat:close()
                        else
                            last_chat:reopen()
                        end
                    else
                        chat.new({window_type = 'split'}, function(_, _) end)
                    end
                end,
                desc = 'cody: toggle',
            },
        },
        -- lazy = false,
        opts = {accept_tos = true},
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    -- -- Flash enhances the built-in search functionality by showing labels
    -- -- at the end of each match, letting you quickly jump to a specific location.
    -- { -- https://github.com/folke/flash.nvim
    --     'folke/flash.nvim',
    --     event = 'VeryLazy',
    --     opts = {},
    --     keys = {
    --         {
    --             '<leader>ff',
    --             mode = {'n', 'x', 'o'},
    --             function() require('flash').jump() end,
    --             desc = 'Flash',
    --         },
    --         {
    --             '<leader>fs',
    --             mode = {'n', 'o', 'x'},
    --             function() require('flash').treesitter() end,
    --             desc = 'Flash Treesitter',
    --         },
    --         {
    --             '<leader>fr',
    --             mode = 'o',
    --             function() require('flash').remote() end,
    --             desc = 'Remote Flash',
    --         },
    --         {
    --             '<leader>fR',
    --             mode = {'o', 'x'},
    --             function() require('flash').treesitter_search() end,
    --             desc = 'Treesitter Search',
    --         },
    --         -- {
    --         --     '<c-s>',
    --         --     mode = {'c'},
    --         --     function() require('flash').toggle() end,
    --         --     desc = 'Toggle Flash Search',
    --         -- },
    --     },
    -- },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/nelstrom/vim-visual-star-search
        'nelstrom/vim-visual-star-search',
        event = {'BufReadPost', 'BufNewFile'},
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/andrew-grechkin/vim-grepper
        'andrew-grechkin/vim-grepper',
        lazy = false,
        init = function()
            vim.cmd [[
                let g:grepper = {}
            ]]
        end,
        config = function()
            vim.cmd [[
                runtime plugin/grepper.vim                                         " initialize g:grepper with default values
                let g:grepper.highlight   = 1
                let g:grepper.jump        = 0
                let g:grepper.quickfix    = 1
                "let g:grepper.dir         = 'repo,cwd,file' do not uncomment. operator stops working
                let g:grepper.repo        = ['.git', '.hg', '.svn', '.cache']
                let g:grepper.searchreg   = 1
                let g:grepper.side        = 0
                let g:grepper.stop        = 2000
                let g:grepper.tools       = ['rg', 'git', 'ag', 'ack', 'ack-grep', 'grep']
                let g:grepper.git.grepprg .= ' -i'

                let g:grepper.operator.git.grepprg .= ' -i'
                let g:grepper.operator.tools        = ['rg', 'git', 'ag', 'ack', 'ack-grep', 'grep']

                nnoremap <silent> <plug>(GrepperOperatorRepo) :let      g:grepper.operator.dir='repo,cwd,file' <BAR> set opfunc=GrepperOperator<CR>g@
                nnoremap <silent> <plug>(GrepperOperatorFile) :let      g:grepper.operator.dir='file,repo,cwd' <BAR> set opfunc=GrepperOperator<CR>g@
                vnoremap <silent> <plug>(GrepperOperatorRepo) :<C-u>let g:grepper.operator.dir='repo,cwd,file' <BAR> call GrepperOperator(visualmode())<CR>
                vnoremap <silent> <plug>(GrepperOperatorFile) :<C-u>let g:grepper.operator.dir='file,repo,cwd' <BAR> call GrepperOperator(visualmode())<CR>
            ]]

            local wk_ok, which_key = pcall(require, 'which-key')
            if wk_ok then
                local normal_mappings = {
                    ['<leader>'] = {
                        -- Search for the current word
                        ['*'] = {'<Esc>:Grepper -dir file -cword -noprompt<CR>', 'grep: file'},
                        ['8'] = {'<Esc>:Grepper -dir repo -cword -noprompt<CR>', 'grep: repo'},
                        -- Start Grepper prompt
                        ['G'] = {'<Esc>:Grepper -dir file<CR>', 'grep: file'},
                        ['g'] = {'<Esc>:Grepper -dir repo<CR>', 'grep: repo'},
                    },
                    ['g'] = {
                        -- Search for the current selection or {motion} (see text-objects)
                        ['S'] = {'<Plug>(GrepperOperatorFile)', 'grep: file'},
                        ['s'] = {'<Plug>(GrepperOperatorRepo)', 'grep: repo'},
                    },
                }
                local visual_mappings = {
                    ['<leader>'] = {
                        -- Search current selection (alias for gs in visual mode)
                        ['G'] = {'<Plug>(GrepperOperatorFile)', 'grep: file'},
                        ['g'] = {'<Plug>(GrepperOperatorRepo)', 'grep: repo'},
                    },
                    ['g'] = {
                        ['S'] = {'<Plug>(GrepperOperatorFile)', 'grep: file'},
                        ['s'] = {'<Plug>(GrepperOperatorRepo)', 'grep: repo'},
                    },
                }
                which_key.register(normal_mappings, {mode = 'n', nowait = true, noremap = true})
                which_key.register(visual_mappings, {mode = 'v', nowait = true, noremap = true})
            end
        end,
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/kevinhwang91/nvim-bqf
        'kevinhwang91/nvim-bqf',
        config = function()
            vim.cmd(([[
                aug Grepper
                    au!
                    au User Grepper ++nested %s
                aug END
            ]]):format([[call setqflist([], 'r', {'context': {'bqf': {'pattern_hl': '\%#' . getreg('/')}}})]]))

            function _G.quickfixtextfunc(info)
                -- The name of item in list is based on the directory of quickfix window.
                -- Change the directory for quickfix window make the name of item shorter.
                -- It's a good opportunity to change current directory in quickfixtextfunc :)
                --
                -- local alterBufnr = vim.fn.bufname('#') -- alternative buffer is the buffer before enter qf window
                -- local root = getRootByAlterBufnr(alterBufnr)
                -- vim.cmd(('noa lcd %s'):format(vim.fn.fnameescape(root)))
                --
                local items

                if info.quickfix == 1 then
                    items = T(vim.fn.getqflist({id = info.id, items = 0}).items)
                else
                    items = T(vim.fn.getloclist(info.winid, {id = info.id, items = 0}).items)
                end

                local cache_len = {}
                local cache_str = {}
                local hard_limit = 50
                local hard_fmt = '%.' .. hard_limit .. 's'

                items:each(function(it)
                    local fname = ''
                    if it.valid == 1 then
                        if it.bufnr > 0 then
                            fname = vim.fn.bufname(it.bufnr)
                            if fname == '' then
                                fname = '[No Name]'
                            else
                                fname = fname:gsub('^' .. vim.env.HOME, '~')
                            end
                        end
                        it.lnum = it.lnum > 99999 and -1 or it.lnum
                        it.col = it.col > 999 and -1 or it.col
                        it.qtype = it.type == '' and '' or ' ' .. it.type:sub(1, 1):upper()

                        if cache_str[it.bufnr] == nil then
                            local len = string.len(fname)
                            if hard_limit < len then
                                fname = '' .. hard_fmt:format(fname:sub(1 - hard_limit))
                                len = hard_limit
                            end
                            cache_str[it.bufnr] = fname
                            cache_len[it.bufnr] = len
                        end

                        it.fname = cache_str[it.bufnr]
                        it.fname_len = cache_len[it.bufnr]
                    end
                end)

                local limit = items:reduce(0, function(acc, it)
                    if it.fname_len > acc then acc = it.fname_len end
                    return acc
                end)

                local soft_fmt = '%-' .. limit .. 's'
                local validFmt = '%s │%5d:%-3d│%s %s'

                return items:map(function(it)
                    local str
                    if it.valid == 1 then
                        if it.fname_len ~= hard_limit then it.fname = soft_fmt:format(it.fname) end
                        str = validFmt:format(it.fname, it.lnum, it.col, it.qtype, it.text)
                    else
                        str = it.text
                    end
                    return str
                end)
            end

            vim.o.quickfixtextfunc = '{info -> v:lua._G.quickfixtextfunc(info)}'

            vim.cmd([[
                hi BqfPreviewFloat  guibg=#111111
                hi BqfPreviewBorder guibg=#111111
                hi BqfPreviewTitle  guibg=#111111 guifg=#EF5939
            ]])

            require('bqf').setup({
                auto_enable = true,
                auto_resize_height = true,
                filter = {
                    fzf = {
                        action_for = {['ctrl-x'] = '', ['ctrl-s'] = 'split'},
                        extra_opts = {
                            '--bind=alt-a:toggle-all',
                            '--bind=tab:toggle+down',
                            '--bind=btab:toggle+up',
                            '--delimiter',
                            '│',
                        },
                    },
                },
                func_map = {pscrolldown = '<C-d>', pscrollup = '<C-u>', split = '<C-s>'},
                magic_window = true,
                preview = {winblend = 0},
            })
            -- :lua =require('bqf.config')
        end,
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    -- search/replace in multiple files
    -- { -- https://github.com/nvim-pack/nvim-spectre
    --     'nvim-pack/nvim-spectre',
    --     dependencies = {'nvim-lua/plenary.nvim'},
    --     cmd = 'Spectre',
    --     opts = {open_cmd = 'noswapfile vnew'},
    --     keys = {
    --         {'<leader>SS', function() require('spectre').toggle() end, desc = 'spectre: toggle'},
    --         {
    --             '<leader>Sw',
    --             function() require('spectre').open_visual({select_word = true}) end,
    --             desc = 'spectre: cur word',
    --         },
    --         {
    --             '<leader>Sw',
    --             function() require('spectre').open_visual() end,
    --             mode = 'v',
    --             desc = 'spectre: cur word',
    --         },
    --         {
    --             '<leader>Sf',
    --             function() require('spectre').open_file_search({select_word = true}) end,
    --             desc = 'spectre: cur word in file',
    --         },
    --     },
    -- },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    -- { -- https://github.com/dyng/ctrlsf.vim
    --     'dyng/ctrlsf.vim',

    --     config = function()
    --         vim.g.ctrlsf_auto_focus = {at = 'done', duration_less_than = 2000}
    --         -- vim.g.ctrlsf_debug_mode = 1
    --         vim.g.ctrlsf_default_root = 'project+wf'
    --         -- vim.g.ctrlsf_default_view_mode  = 'compact'
    --         vim.g.ctrlsf_extra_backend_args = {ag = '--hidden --nofollow', rg = '--hidden'}
    --         vim.g.ctrlsf_extra_root_markers = {'.git', '.hg', '.svn', '.cache'}
    --         vim.g.ctrlsf_follow_symlinks = 0
    --         vim.g.ctrlsf_ignore_dir = {'.git', 'bower_components', 'node_modules'}
    --         vim.g.ctrlsf_parse_speed = 100
    --         vim.g.ctrlsf_position = 'bottom'
    --         local wk_ok, which_key = pcall(require, 'which-key')
    --         if wk_ok then
    --             local normal_mappings = {
    --                 ['<leader>'] = {s = {f = {'<Plug>CtrlSFPrompt', 'ctrl-f: prompt'}}},
    --             }
    --             local visual_mappings = {
    --                 ['<leader>'] = {s = {f = {'<Plug>CtrlSFVwordExec', 'ctrl-f: word'}}},
    --             }
    --             which_key.register(normal_mappings, {mode = 'n', nowait = true, noremap = true})
    --             which_key.register(visual_mappings, {mode = 'v', nowait = true, noremap = true})
    --         end
    --     end,
    -- },
}
