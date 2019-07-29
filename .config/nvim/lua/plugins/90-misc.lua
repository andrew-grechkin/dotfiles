return {
    { -- https://github.com/ellisonleao/glow.nvim
        'ellisonleao/glow.nvim',
        enabled = not IS_KVM,
        config = true,
        cmd = 'Glow',
        opts = {
            -- glow_path = "", -- will be filled automatically with your glow bin in $PATH, if any
            -- install_path = "~/.cache/bin", -- default path for installing glow binary
            border = 'shadow', -- floating window border config
            style = 'dark', -- filled automatically with your current editor background, you can override using glow json style
            pager = false,
            width_ratio = 0.9, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
            height_ratio = 0.9,
        },
    },
    {'gianarb/vim-flux', enabled = not IS_KVM, ft = {'flux'}},
    {'mgrabovsky/vim-cuesheet', enabled = not IS_KVM, ft = {'cuesheet'}},
    {'pearofducks/ansible-vim', enabled = not IS_KVM, ft = {'ansible'}},
    {'potamides/pantran.nvim', enabled = not IS_KVM, cmd = {'Pantran'}},
    {'tmux-plugins/vim-tmux', enabled = not IS_KVM, ft = {'tmux'}},
    {
        'vimwiki/vimwiki',
        enabled = not IS_KVM,
        cmd = {'VimwikiIndex'},
        init = function()
            vim.g.vimwiki_global_ext = 0
            vim.g.vimwiki_table_mappings = 0
            vim.g.vimwiki_list = {{path = '~/.local/share/wiki', syntax = 'markdown', ext = '.md'}}
        end,
    },
    -- 'vim-ruby/vim-ruby',
    -- '~/.local/share/vim-plug/perlart',
    -- '~/.local/share/vim-plug/trackperlvars',
}
