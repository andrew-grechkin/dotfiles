-- url: https://github.com/neovim/nvim-lspconfig
if vim.g.lspconfig ~= nil then
	--vim.lsp.set_log_level("debug")

	local nvim_lsp = require('lspconfig')
	local protocol = require('vim.lsp.protocol')

	-- Use an on_attach function to only map the following keys
	-- after the language server attaches to the current buffer
	local on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	--Enable completion triggered by <c-x><c-o>
	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	local opts = { noremap=true, silent=true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
	--buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	--buf_set_keymap('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
	--buf_set_keymap('n', '<C-j>', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', '<S-C-j>', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
	buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
	buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

	-- formatting
	if client.resolved_capabilities.document_formatting then
		vim.api.nvim_command [[augroup Format]]
		vim.api.nvim_command [[autocmd! * <buffer>]]
		vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
		vim.api.nvim_command [[augroup END]]
	end

	if vim.g.loaded_completion ~= nil then
		require'completion'.on_attach(client, bufnr)

		--protocol.SymbolKind = { }
		protocol.CompletionItemKind = {
			'', -- Class
			'', -- Color
			'', -- Constant
			'', -- Constructor
			'', -- Enum
			'', -- EnumMember
			'', -- Event
			'', -- Field
			'', -- File
			'', -- Folder
			'', -- Function
			'ﰮ', -- Interface
			'', -- Keyword
			'', -- Method
			'', -- Module
			'ﬦ', -- Operator
			'', -- Property
			'', -- Reference
			'﬌', -- Snippet
			'', -- Struct
			'', -- Text
			'', -- TypeParameter
			'', -- Unit
			'', -- Value
			'', -- Variable
		}
	end
end

nvim_lsp.bashls.setup{
on_attach = on_attach
}
nvim_lsp.clangd.setup{
on_attach = on_attach
}
nvim_lsp.cmake.setup{
on_attach = on_attach
}
nvim_lsp.dockerls.setup{
	on_attach = on_attach
}
nvim_lsp.flow.setup{
	cmd = { "npx", "--no-install", "flow", "lsp" },
	-- filetypes = { "javascript", "javascriptreact", "javascript.jsx" },
	-- root_dir = root_pattern(".flowconfig"),
}
nvim_lsp.gopls.setup{
on_attach = on_attach
}
nvim_lsp.graphql.setup{
on_attach = on_attach
}
--Enable (broadcasting) snippet capability for completion
--local capabilities = vim.lsp.protocol.make_client_capabilities()
--capabilities.textDocument.completion.completionItem.snippetSupport = true

nvim_lsp.html.setup {
	--capabilities = capabilities,
	on_attach = on_attach
	}

nvim_lsp.jsonls.setup{
on_attach = on_attach
}
--nvim_lsp.perlls.setup{
--  on_attach = on_attach
--}
nvim_lsp.puppet.setup{
on_attach = on_attach
}
nvim_lsp.stylelint_lsp.setup{
on_attach = on_attach,
settings = {
	stylelintplus = {
		-- see available options in stylelint-lsp documentation
		}
	}
}
nvim_lsp.vimls.setup{
on_attach = on_attach
}
nvim_lsp.vuels.setup{
on_attach = on_attach
}
nvim_lsp.yamlls.setup{
on_attach = on_attach
}

nvim_lsp.flow.setup {
	on_attach = on_attach
	}

nvim_lsp.tsserver.setup {
	on_attach = on_attach,
	filetypes = { "typescript", "typescriptreact", "typescript.tsx" }
	}

nvim_lsp.diagnosticls.setup {
	on_attach = on_attach,
	filetypes = { 'javascript', 'javascriptreact', 'json', 'typescript', 'typescriptreact', 'css', 'less', 'scss', 'markdown', 'pandoc' },
	init_options = {
		linters = {
			eslint = {
				command = 'eslint_d',
				rootPatterns = { '.git' },
				debounce = 100,
				args = { '--stdin', '--stdin-filename', '%filepath', '--format', 'json' },
				sourceName = 'eslint_d',
				parseJson = {
					errorsRoot = '[0].messages',
					line = 'line',
					column = 'column',
				endLine = 'endLine',
			endColumn = 'endColumn',
			message = '[eslint] ${message} [${ruleId}]',
			security = 'severity'
			},
		securities = {
			[2] = 'error',
			[1] = 'warning'
			}
		},
	},
filetypes = {
	javascript = 'eslint',
	javascriptreact = 'eslint',
	typescript = 'eslint',
	typescriptreact = 'eslint',
	},
formatters = {
	eslint_d = {
		command = 'eslint_d',
		args = { '--stdin', '--stdin-filename', '%filename', '--fix-to-stdout' },
		rootPatterns = { '.git' },
		},
	prettier = {
		command = 'prettier',
		args = { '--stdin-filepath', '%filename' }
		}
	},
formatFiletypes = {
	css = 'prettier',
	javascript = 'eslint_d',
	javascriptreact = 'eslint_d',
	json = 'prettier',
	less = 'prettier',
	markdown = 'prettier',
	scss = 'prettier',
	typescript = 'eslint_d',
	typescriptreact = 'eslint_d',
	}
}
}

-- icon
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
vim.lsp.diagnostic.on_publish_diagnostics, {
	underline = true,
	-- This sets the spacing and the prefix, obviously.
	virtual_text = {
		spacing = 4,
		prefix = ''
		}
	}
)
end
