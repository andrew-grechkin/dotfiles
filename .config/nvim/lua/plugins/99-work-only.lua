if IS_WORK then
    if IS_KVM then
        local fzf_dir = vim.fn.stdpath('cache') .. '/../fzf'
        if not vim.loop.fs_stat(fzf_dir) then
            print('Fetching fzf binary')
            vim.fn.system({'git', 'clone', 'https://github.com/junegunn/fzf', fzf_dir})
            vim.fn.system({fzf_dir .. '/install', '--bin'})
        end
        return {
            { -- url: https://github.com/junegunn/fzf
                'junegunn/fzf',
                dir = fzf_dir,
                build = './install --bin',
            },
        }
    else
        return {
            { -- url: https://github.com/shumphrey/fugitive-gitlab.vim
                'shumphrey/fugitive-gitlab.vim',
                config = function()
                    local PRIVATE_DOMAIN = vim.api.nvim_get_var('PRIVATE_DOMAIN')
                    vim.g.fugitive_gitlab_domains = {'https://gitlab.' .. PRIVATE_DOMAIN .. '.com'}
                end,
            },
            'rodjek/vim-puppet',
            'towolf/vim-helm',
            -- 'elixir-editors/vim-elixir',
            -- 'fatih/vim-go',
        }
    end
else
    return {}
end
