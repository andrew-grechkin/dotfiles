return {
    { -- url: https://github.com/tpope/vim-commentary
        'tpope/vim-commentary',
        dependencies = {'suy/vim-context-commentstring'},
        config = function()
            vim.cmd [[
                nmap     <C-_>                         gcl
                vmap     <C-_>                         gc

                augroup SettingsVimCommentary
                    autocmd!
                    autocmd FileType perl,vim let b:commentary_startofline = 1
                augroup END
            ]]
        end,
    },
}
