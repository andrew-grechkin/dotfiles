return {
    { -- https://github.com/nvim-neotest/neotest
        'nvim-neotest/neotest',
        dependencies = {
            'nvim-neotest/neotest-plenary', 'nvim-neotest/neotest-python',
            'nvim-neotest/neotest-vim-test',
        },
        config = function()
            local ok, plugin = pcall(require, 'neotest')
            if not ok then return end

            local config = {}

            plugin.setup(config)
        end,
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/janko/vim-test
        'janko/vim-test',
        config = function()
            vim.api.nvim_exec([[

let g:test#strategy                = 'neovim'
let g:test#perl#prove#executable   = 'yath test --qvf'
let g:test#perl#prove#file_pattern = '\v(/|^)x?t/.*\.t$'

augroup PluginVimTest
	autocmd!
	autocmd FileType perl nmap <silent> <leader>th :let $T2_WORKFLOW = line(".") <bar> :TestFile<CR>
	autocmd FileType perl nmap <silent> <leader>te :let $T2_WORKFLOW = ""        <bar> :TestFile<CR>
augroup END

]], false)
        end,
    },
}
