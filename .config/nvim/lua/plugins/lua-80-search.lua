return {
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
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/mhinz/vim-grepper
        'mhinz/vim-grepper',
        lazy = false,
        config = function()
            vim.api.nvim_exec([[

runtime plugin/grepper.vim                                         " initialize g:grepper with default values
let g:grepper.highlight   = 1
let g:grepper.jump        = 0
let g:grepper.quickfix    = 0
let g:grepper.dir         = 'repo,cwd,file'
let g:grepper.repo        = ['.git', '.hg', '.svn', '.cache']
let g:grepper.side        = 0
let g:grepper.stop        = 255
let g:grepper.tools       = ['git', 'rg', 'ag', 'ack', 'ack-grep', 'grep']
let g:grepper.ag.grepprg .= ' --hidden'
let g:grepper.rg.grepprg .= ' --hidden --smart-case'

nnoremap <silent> <plug>(GrepperOperatorRepo) :let g:grepper.operator.dir='repo,cwd,file' <bar> set opfunc=GrepperOperator<cr>g@
nnoremap <silent> <plug>(GrepperOperatorFile) :let g:grepper.operator.dir='file,repo,cwd' <bar> set opfunc=GrepperOperator<cr>g@
vnoremap <silent> <plug>(GrepperOperatorRepo) :<c-u>let g:grepper.operator.dir='repo,cwd,file' <bar> call GrepperOperator(visualmode())<CR>
vnoremap <silent> <plug>(GrepperOperatorFile) :<c-u>let g:grepper.operator.dir='file,repo,cwd' <bar> call GrepperOperator(visualmode())<CR>

]], false)
            local wk_ok, which_key = pcall(require, 'which-key')
            if wk_ok then
                local normal_mappings = {
                    ['<leader>'] = {
                        -- Search for the current word
                        ['*'] = {'<Esc>:Grepper -dir file -cword -noprompt<CR>', 'grep: dir'},
                        ['8'] = {'<Esc>:Grepper -dir repo -cword -noprompt<CR>', 'grep: repo'},
                        -- Start Grepper prompt
                        ['G'] = {'<Esc>:Grepper -dir file<CR>', 'grep: dir'},
                        ['g'] = {'<Esc>:Grepper -dir repo<CR>', 'grep: repo'},
                    },
                    ['g'] = {
                        -- Search for the current selection or {motion} (see text-objects)
                        ['S'] = {'<Plug>(GrepperOperatorFile)', 'grep: dir'},
                        ['s'] = {'<Plug>(GrepperOperatorRepo)', 'grep: repo'},
                    },
                }
                local visual_mappings = {
                    ['<leader>'] = {
                        -- Search current selection (alias for gs in visual mode)
                        ['G'] = {'<Plug>(GrepperOperatorFile)', 'grep: dir'},
                        ['g'] = {'<Plug>(GrepperOperatorRepo)', 'grep: repo'},
                    },
                    ['g'] = {
                        ['S'] = {'<Plug>(GrepperOperatorFile)', 'grep: dir'},
                        ['s'] = {'<Plug>(GrepperOperatorRepo)', 'grep: repo'},
                    },
                }
                which_key.register(normal_mappings, {mode = 'n', nowait = true, noremap = true})
                which_key.register(visual_mappings, {mode = 'v', nowait = true, noremap = true})
            end
        end,
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    -- search/replace in multiple files
    { -- https://github.com/nvim-pack/nvim-spectre
        'nvim-pack/nvim-spectre',
        dependencies = {'nvim-lua/plenary.nvim'},
        cmd = 'Spectre',
        opts = {open_cmd = 'noswapfile vnew'},
        keys = {
            {'<leader>SS', function() require('spectre').toggle() end, desc = 'spectre: toggle'},
            {
                '<leader>Sw',
                function() require('spectre').open_visual({select_word = true}) end,
                desc = 'spectre: cur word',
            },
            {
                '<leader>Sw',
                function() require('spectre').open_visual() end,
                mode = 'v',
                desc = 'spectre: cur word',
            },
            {
                '<leader>Sf',
                function() require('spectre').open_file_search({select_word = true}) end,
                desc = 'spectre: cur word in file',
            },
        },
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/dyng/ctrlsf.vim
        'dyng/ctrlsf.vim',

        config = function()
            vim.g.ctrlsf_auto_focus = {at = 'done', duration_less_than = 2000}
            -- vim.g.ctrlsf_debug_mode = 1
            vim.g.ctrlsf_default_root = 'project+wf'
            -- vim.g.ctrlsf_default_view_mode  = 'compact'
            vim.g.ctrlsf_extra_backend_args = {ag = '--hidden --nofollow', rg = '--hidden'}
            vim.g.ctrlsf_extra_root_markers = {'.git', '.hg', '.svn', '.cache'}
            vim.g.ctrlsf_follow_symlinks = 0
            vim.g.ctrlsf_ignore_dir = {'.git', 'bower_components', 'node_modules'}
            vim.g.ctrlsf_parse_speed = 100
            vim.g.ctrlsf_position = 'bottom'
            local wk_ok, which_key = pcall(require, 'which-key')
            if wk_ok then
                local normal_mappings = {
                    ['<leader>'] = {s = {f = {'<Plug>CtrlSFPrompt', 'ctrl-f: prompt'}}},
                }
                local visual_mappings = {
                    ['<leader>'] = {s = {f = {'<Plug>CtrlSFVwordExec', 'ctrl-f: word'}}},
                }
                which_key.register(normal_mappings, {mode = 'n', nowait = true, noremap = true})
                which_key.register(visual_mappings, {mode = 'v', nowait = true, noremap = true})
            end
        end,
    },
    -- -- => --------------------------------------------------------------------------------------------------------- {{{1
    -- { -- https://github.com/sourcegraph/sg.nvim
    --     'sourcegraph/sg.nvim',
    --     dependencies = {'nvim-lua/plenary.nvim'},
    -- },
}
