-- [[ Open help window in a vertical split to the right ]]
-- vim.api.nvim_create_autocmd('BufWinEnter', {
--     group = vim.api.nvim_create_augroup('help_window_right', {}),
--     pattern = {'*.txt'},
--     callback = function() if vim.o.filetype == 'help' then vim.cmd.wincmd('L') end end,
-- })
vim.api.nvim_create_autocmd('FileType', {pattern = {'help', 'man'}, command = 'wincmd L'})

local function augroup(name) return vim.api.nvim_create_augroup('lconfig_' .. name, {clear = true}) end

-- [[ open quickfix after make command ]]
-- vim.api.nvim_create_autocmd('QuickFixCmdPost', {
--     group = augroup('OpenQuickFix'),
--     pattern = '*',
--     command = 'copen',
-- })

-- [[ change CWD according to the project root ]]
-- local rooter_notify_rec = nil
-- vim.api.nvim_create_autocmd({'BufReadPost', 'VimEnter'}, {
vim.api.nvim_create_autocmd('BufReadPost', {
    group = augroup('WindowAutoCD'),
    callback = function(ev)
        -- local notify_ok, notify = pcall(require, 'notify')
        local cwd = vim.loop.cwd()
        -- vim.notify(cwd)
        local dir = GET_PROJECT_DIR(ev.match)
        -- vim.notify(dir)
        if cwd ~= dir then
            vim.cmd('lcd ' .. dir)
            -- if notify_ok then
            --     rooter_notify_rec = notify.notify(string.format('%s', dir), 'INFO',
            --         {title = 'Project root detected', replace = rooter_notify_rec})
            -- end
        end

        local ok, plugin = pcall(require, 'dap.ext.vscode')
        if ok then pcall(plugin.load_launchjs, nil) end -- load launch.json
    end,
})

if vim.o.diff then
    vim.o.spell = false
    vim.o.cmdheight = 2
else
    vim.api.nvim_create_autocmd('BufWinEnter', {
        group = augroup('RestorePosition'),
        command = 'silent! loadview',
    })
    vim.api.nvim_create_autocmd('BufWinLeave', {
        group = augroup('SavePosition'),
        command = 'silent! mkview',
    })
end

-- [[ Check if we need to reload the file when it changed ]]
vim.api.nvim_create_autocmd({
    'BufEnter',
    'CursorHold',
    'CursorHoldI',
    'FocusGained',
    'TermClose',
    'TermLeave',
}, {group = augroup('Checktime'), command = 'silent! checktime'})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    group = augroup('YankHighlight'),
    pattern = '*',
    callback = function() vim.highlight.on_yank() end,
})

-- [[ resize splits if window got resized ]]
vim.api.nvim_create_autocmd({'VimResized'}, {
    group = augroup('ResizeSplits'),
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd('tabdo wincmd =')
        vim.cmd('tabnext ' .. current_tab)
    end,
})

-- vim.api.nvim_create_autocmd('FileType', {
--     group = augroup('SetTextWidth'),
--     callback = function(event)
--         vim.bo[event.buf].textwidth = 120
--         vim.bo[event.buf].wrapmargin = 0
--     end,
-- })

vim.api.nvim_create_autocmd('FileType', {
    group = augroup('HideBuffer'),
    pattern = 'fugitive://*',
    callback = function(event) vim.bo[event.buf].bufhidden = 'delete' end,
})

-- [[ close some filetypes with <q> ]]
vim.api.nvim_create_autocmd('FileType', {
    group = augroup('CloseWithQ'),
    pattern = {
        'PlenaryTestPopup',
        'Run',
        'checkhealth',
        'fugitiveblame',
        'git',
        'help',
        'lspinfo',
        'man',
        'neotest-output',
        'neotest-output-panel',
        'neotest-summary',
        'notify',
        'qf',
        'query',
        'spectre_panel',
        'startuptime',
        'tsplayground',
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set('n', 'q', '<cmd>bd<cr>', {buffer = event.buf, silent = true})
    end,
})
vim.api.nvim_create_autocmd({'BufEnter'}, {
    group = augroup('CloseWithQ2'),
    callback = function(event)
        local buftype = vim.api.nvim_buf_get_option(event.buf, 'buftype')
        if buftype == 'nofile' or buftype == 'loclist' then
            vim.bo[event.buf].buflisted = false
            vim.keymap.set('n', 'q', '<cmd>bd<cr>', {buffer = event.buf, silent = true})
        end
    end,
})

-- [[ wrap and check for spell in text filetypes ]]
vim.api.nvim_create_autocmd('FileType', {
    group = augroup('AutoSpell'),
    pattern = {'gitcommit', 'markdown'},
    callback = function() vim.opt_local.spell = true end,
})

-- [[ Auto create dir when saving a file, in case some intermediate directory does not exist ]]
vim.api.nvim_create_autocmd({'BufWritePre'}, {
    group = augroup('AutoCreateDir'),
    callback = function(event)
        if event.match:match('^%w%w+://') then return end
        local file = vim.loop.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
    end,
})
