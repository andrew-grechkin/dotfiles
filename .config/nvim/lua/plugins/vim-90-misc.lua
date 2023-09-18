if not IS_KVM then
    return {
        {
            'ellisonleao/glow.nvim',
            'gianarb/vim-flux',
            'jghauser/mkdir.nvim',
            'mgrabovsky/vim-cuesheet',
            'pearofducks/ansible-vim',
            'potamides/pantran.nvim',
            'tmux-plugins/vim-tmux',
            'tpope/vim-rhubarb',
            'vimwiki/vimwiki',
            -- 'vim-ruby/vim-ruby',
            -- '~/.local/share/vim-plug/perlart',
            -- '~/.local/share/vim-plug/trackperlvars',
        },
    }
else
    return {}
end
