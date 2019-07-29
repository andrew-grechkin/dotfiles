-- => whole file text object -------------------------------------------------------------------------------------- {{{1
--
-- There is no text object for the whole file by default, but it is possible to create them using omap. In this case, it would look something like this:
--
-- onoremap f :<c-u>normal! mzggVG<cr>`z
--
-- Here is a breakdown of how it works:
-- onoremap f " make 'f' the text object name
-- :<c-u> " use <c-u> to prevent vim from inserting visual selection marker at the beginning of the command automatically.
-- normal! " use normal to make key presses ignoring any user mappings
-- mzggVG<cr>`z " make a marker in register z, select the entire file in visual line mode and enter the normal command, and go back to the z marker
-- Notes:
-- Ctrl-u can be used in the command line mode to delete everything to the left of the cursor position. The reason why this is done is because if you enter the command line straight from visual mode, it will automatically insert '<,'> on the command line, and that isn't what we want. I would also suggest you use something other than f, because f is normally used to move to the next searched character on the line. For example, fi will go to the next i on the current line.
-- Relevant help topics:
-- :help omap-info
-- :help :normal
-- :help c_CTRL-U
-- :help v_:
vim.keymap.set('o', 'q', ':<C-u>normal! mzggVG<CR>`z', {desc = 'Object: whole file'})
vim.keymap.set('o', 'V', ':<C-u>normal! mz0V<CR>`z', {desc = 'Object: whole line'})

vim.keymap.set('n', '<leader>ts', ':set spell!<CR>', {desc = ' spelling'})
vim.keymap.set('n', '<leader>tw', ':set wrap!<CR>', {desc = ' word wrap'})

vim.keymap.set('n', '<leader>tc', function()
    if vim.o.conceallevel == 3 then
        vim.o.conceallevel = 0
    else
        vim.o.conceallevel = 3
    end
end, {desc = ' conceal'})

vim.keymap.set('n', '<leader>td', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end,
    {desc = ' diagnostics'})

if vim.lsp.inlay_hint and vim.lsp.inlay_hint.enable then
    vim.keymap.set('n', '<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
        {desc = ' inlay hints'})
end

vim.keymap.set('n', '<leader>tl', function()
    if vim.lsp.status() then
        vim.lsp.stop()
    else
        vim.lsp.start()
    end
end, {desc = ' lsp'})

vim.keymap.set('n', '<leader>tT', function()
    if vim.b.ts_highlight then
        vim.treesitter.stop()
    else
        vim.treesitter.start()
    end
end, {desc = ' treesitter highlight'})
