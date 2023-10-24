local status_lsp_config, _ = pcall(require, 'lspconfig')
if not status_lsp_config then return end

local status, plugin_installer = pcall(require, 'nvim-lsp-installer')
if not status then return end

local status_handlers, plugin_handlers = pcall(require, 'lsp.0-handlers')
if not status_handlers then return end

plugin_installer.on_server_ready(function(server)
    local opts = {
        on_attach = plugin_handlers.on_attach,
        capabilities = plugin_handlers.capabilities,
    }

    local servers = {'sumneko_lua'}

    for _, name in ipairs(servers) do
        local req_name = string.format('lsp.settings-%s', name)
        local ok, settings = pcall(require, req_name)
        if ok then opts = vim.tbl_deep_extend('force', settings, opts) end
    end

    -- This setup() function is exactly the same as lspconfig's setup function.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(opts)
end)

plugin_handlers.setup()
