-- local fzf_dir = vim.fn.stdpath('cache') .. '/../fzf'
-- if not vim.loop.fs_stat(fzf_dir) then
--     print('Fetching fzf binary')
--     vim.fn.system({'git', 'clone', 'https://github.com/junegunn/fzf', fzf_dir})
--     vim.fn.system({fzf_dir .. '/install', '--bin'})
-- end
return {
    {'rodjek/vim-puppet', enabled = IS_WORK and not IS_KVM, ft = {'puppet'}},
    {'towolf/vim-helm', enabled = IS_WORK and not IS_KVM},
    -- 'elixir-editors/vim-elixir',
}
