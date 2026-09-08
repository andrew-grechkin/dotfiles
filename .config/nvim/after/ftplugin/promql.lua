-- Start a tenant-scoped PromQL language server for this buffer.
-- Tenant is detected from the filename: `<tenant>.<anything>.promql` -> <tenant>.
-- Falls back to `$MIMIR_LSP_TENANT`, then 'dlb'. Each tenant gets its own LSP instance
-- (named `promql-<tenant>`), reused across buffers via `vim.lsp.start`'s idempotence.

if vim.fn.executable('mimir') == 0 then return end

local filepath = vim.api.nvim_buf_get_name(0)
local basename = vim.fn.fnamemodify(filepath, ':t')
local tenant = basename:match('^([^.]+)%..+%.promql$')
                or vim.env.MIMIR_LSP_TENANT
                or 'dlb'

-- Advertise cmp-nvim-lsp's extended completion capabilities so promql-langserver
-- returns rich completion items. If cmp-nvim-lsp isn't loaded yet, fall back to core capabilities.
local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
local capabilities = ok and cmp_nvim_lsp.default_capabilities() or vim.lsp.protocol.make_client_capabilities()

vim.lsp.start({
    name = 'promql-' .. tenant,
    cmd = {'mimir', 'lsp', tenant},
    cmd_env = {DOMAIN = vim.env.DOMAIN},
    filetypes = {'promql'},
    root_dir = (filepath ~= '' and vim.fs.dirname(filepath)) or vim.fn.getcwd(),
    capabilities = capabilities,
})
