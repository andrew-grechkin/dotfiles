return { -- https://github.com/microsoft/vscode-json-languageservice
    settings = {['json'] = {}},
    set_prepare = function(_, settings)
        settings['capabilities'] = vim.lsp.protocol.make_client_capabilities()
        settings['capabilities'].textDocument.completion.completionItem.snippetSupport = true
    end,
    set_on_attach = function(_, _) end,
}
