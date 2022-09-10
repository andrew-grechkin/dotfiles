local status, plugin = pcall(require, 'lualine')
if not status then return end

plugin.setup {
    options = {
        icons_enabled = true,
        theme = 'modus-vivendi',
        section_separators = '',
        component_separators = '',
        disabled_filetypes = {},
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff'},
        lualine_c = {
            'filename', {
                'diagnostics',
                sources = {'nvim_lsp'},
                symbols = {error = ' ', warn = ' ', info = ' ', hint = ' '},
            },
        },
        lualine_x = {'filetype'},
        lualine_y = {'encoding', 'fileformat'},
        lualine_z = {'filesize', 'progress', 'location'},
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    extensions = {'fugitive', 'nvim-dap-ui', 'quickfix'},
}
