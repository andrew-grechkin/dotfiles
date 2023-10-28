-- local fzf_dir = vim.fn.stdpath('cache') .. '/../fzf'
-- if not vim.loop.fs_stat(fzf_dir) then
--     print('Fetching fzf binary')
--     vim.fn.system({'git', 'clone', 'https://github.com/junegunn/fzf', fzf_dir})
--     vim.fn.system({fzf_dir .. '/install', '--bin'})
-- end
return {
    { -- url: https://github.com/shumphrey/fugitive-gitlab.vim
        'shumphrey/fugitive-gitlab.vim',
        enabled = IS_WORK and not IS_KVM,
        config = function()
            local PRIVATE_DOMAIN = vim.api.nvim_get_var('PRIVATE_DOMAIN')
            vim.g.fugitive_gitlab_domains = {'https://gitlab.' .. PRIVATE_DOMAIN .. '.com'}
        end,
    },
    {'rodjek/vim-puppet', enabled = IS_WORK and not IS_KVM},
    {'towolf/vim-helm', enabled = IS_WORK and not IS_KVM},
    -- 'elixir-editors/vim-elixir',
}
