vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2

vim.api.nvim_create_user_command('SprigDoc', function(args)
    local current_width = vim.api.nvim_win_get_width(0)
    local width = math.floor(current_width * 0.5)
    width = math.max(40, math.min(width, 120))

    vim.cmd('vsplit')
    vim.cmd('vertical resize ' .. width)

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_current_buf(buf)

    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':quit<CR>', {noremap = true, silent = true})
    for _, key in ipairs({'i', 'I', 'a', 'A', 'o', 'O'}) do vim.keymap.set('n', key, '<Nop>', {
        buffer = buf,
    }) end

    local chan = vim.api.nvim_open_term(buf, {})

    vim.fn.jobstart('doc sprig ' .. vim.fn.shellescape(args.args), {
        env = {GLAMOUR_WIDTH = tostring(width)},
        on_stdout = function(_, data) if data then vim.api.nvim_chan_send(chan, table.concat(data, '\n')) end end,
        on_exit = function()
            vim.schedule(function()
                if vim.api.nvim_buf_is_valid(buf) then
                    vim.api.nvim_set_current_buf(buf)
                    vim.cmd('stopinsert')

                    local pattern = vim.fn.escape(args.args, '/\\')
                    vim.fn.setreg('/', pattern)
                    pcall(function() vim.cmd('normal! ggNn') end)
                end
            end)
        end,
        pty = true,
    })
end, {nargs = 1})

vim.opt_local.keywordprg = ':SprigDoc'

vim.keymap.set({'n', 'v'}, '<F5>', ':Filter gotmpl2text<CR>',
    {buffer = true, silent = true, desc = 'Render Go template'})
vim.keymap.set({'n', 'v'}, '<leader><CR>', ':Filter gotmpl2text<CR>',
    {buffer = true, silent = true, desc = 'Render Go template'})
vim.keymap.set({'n'}, '<leader>m', ':Make<CR>', {buffer = true, desc = 'Render Go template'})

vim.cmd('compiler gotmpl2text')

-- https://github.com/yayolande/go-template-lsp
-- go install github.com/yayolande/go-template-lsp@latest
-- not working
-- vim.lsp.start({
--     name = 'go-template-lsp',
--     cmd = {'go-template-lsp'},
--     -- root_dir = vim.fs.root(0, {'go.mod', '.git'}) or vim.loop.cwd(),
--     root_dir = '/home/agrechkin/git/private/dotfiles/',
--     capabilities = vim.lsp.protocol.make_client_capabilities(),
-- })

-- Post-process quickfix: gotmpl2text now emits one 'template: PATH:LINE:COL:'
-- line per frame, so the compiler's errorformat already creates a separate
-- quickfix entry for each frame in the chain (stdin -> preload -> ...).
-- STDIN frames arrive with the literal filename "STDIN" and bufnr=0 (no such
-- buffer); remap them to the current buffer so :cnext lands on the file the
-- user just piped into gotmpl2text.
local function process_gotmpl_errors()
    local qflist = vim.fn.getqflist()
    local current_buf = vim.fn.bufnr('%')
    local current_file = vim.fn.bufname(current_buf)

    for _, item in ipairs(qflist) do
        if item.bufnr == 0 then
            item.bufnr = current_buf
            item.filename = current_file
        end
    end

    vim.fn.setqflist(qflist, 'r')
end

vim.api.nvim_create_autocmd('QuickFixCmdPost', {buffer = 0, callback = process_gotmpl_errors})
