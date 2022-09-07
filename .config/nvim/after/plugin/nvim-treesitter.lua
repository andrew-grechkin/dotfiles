local status, treesitter_configs = pcall(require, 'nvim-treesitter.configs')
if not status then return end

treesitter_configs.setup {
    highlight = {enable = true, disable = {}},
    indent = {enable = false, disable = {}},
    ensure_installed = {
        'bash', 'c', 'cmake', 'cpp', 'css', 'dockerfile', 'elixir', 'gitignore',
        'html', 'http', 'javascript', 'json', 'lua', 'make', 'markdown',
        'markdown_inline', 'python', 'regex', 'ruby', 'scss', 'sql', 'toml',
        'tsx', 'typescript', 'vue', 'yaml',
    },
}

-- local status2, treesitter_parsers = pcall(require, 'nvim-treesitter.parsers')
-- if not status2 then return end

-- local parser_config = treesitter_parsers.get_parser_configs()
-- parser_config.tsx.used_by = { 'javascript', 'typescript.tsx' }
