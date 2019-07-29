return {
    { -- https://github.com/navarasu/onedark.nvim
        'navarasu/onedark.nvim',
        enabled = false,
        config = function()
            require('onedark').setup {
                -- Main options --
                style = 'darker', -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
                transparent = true, -- Show/hide background
                term_colors = true, -- Change terminal color as per the selected theme style
                ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
                cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

                -- toggle theme style ---
                toggle_style_key = '<C-y>', -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
                toggle_style_list = {'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'}, -- List of styles to toggle between

                -- Change code style ---
                -- Options are italic, bold, underline, none
                -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
                code_style = {
                    comments = 'italic',
                    keywords = 'none',
                    functions = 'none',
                    strings = 'none',
                    variables = 'none',
                },

                -- Lualine options --
                lualine = {
                    transparent = false, -- lualine center bar transparency
                },

                -- Custom Highlights --
                colors = {}, -- Override default colors
                highlights = {}, -- Override highlight groups

                -- Plugins Config --
                diagnostics = {
                    darker = true, -- darker colors for diagnostic
                    undercurl = true, -- use undercurl instead of underline for diagnostics
                    background = true, -- use background color for virtual text
                },
            }

            -- load the colorscheme here
            vim.cmd.colorscheme 'onedark'
        end,
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/folke/tokyonight.nvim
        'folke/tokyonight.nvim',
        enabled = false,
        opts = {style = 'moon'},
        config = function()
            -- load the colorscheme here
            -- vim.cmd([[colorscheme tokyonight]])
        end,
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/dracula/vim
        'dracula/vim',
        name = 'dracula.vim',
        enabled = false,
        config = function()
            vim.cmd.colorscheme 'dracula'
            vim.cmd [[
                "set background=dark
                highlight Normal ctermbg=none
                highlight NonText ctermbg=none
                highlight Normal guibg=none
                highlight NonText guibg=none
            ]]
        end,
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/catppuccin/nvim
        'catppuccin/nvim',
        enabled = false,
        name = 'catppuccin',
        config = function()
            require('catppuccin').setup({
                flavour = 'mocha', -- latte, frappe, macchiato, mocha
                background = { -- :h background
                    light = 'latte',
                    dark = 'mocha',
                },
                transparent_background = true, -- disables setting the background color.
                show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
                term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
                dim_inactive = {
                    enabled = false, -- dims the background color of inactive window
                    shade = 'dark',
                    percentage = 0.15, -- percentage of the shade to apply to the inactive window
                },
                no_italic = false, -- Force no italic
                no_bold = false, -- Force no bold
                no_underline = false, -- Force no underline
                styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
                    comments = {'italic'}, -- Change the style of comments
                    conditionals = {'italic'},
                    loops = {},
                    functions = {},
                    keywords = {},
                    strings = {},
                    variables = {},
                    numbers = {},
                    booleans = {},
                    properties = {},
                    types = {},
                    operators = {},
                },
                color_overrides = {},
                custom_highlights = {},
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                    treesitter = true,
                    notify = false,
                    mini = {enabled = true, indentscope_color = ''},
                    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
                },
            })

            -- setup must be called before loading
            vim.cmd.colorscheme 'catppuccin'
        end,
    },
    -- => --------------------------------------------------------------------------------------------------------- {{{1
    { -- https://github.com/NvChad/nvim-colorizer.lua
        'NvChad/nvim-colorizer.lua',
        event = {'BufReadPost', 'BufNewFile'},
        opts = {
            filetypes = {'*'},
            user_default_options = {
                RGB = true, -- #RGB hex codes
                RRGGBB = true, -- #RRGGBB hex codes
                names = true, -- "Name" codes like Blue or blue
                RRGGBBAA = false, -- #RRGGBBAA hex codes
                AARRGGBB = false, -- 0xAARRGGBB hex codes
                rgb_fn = false, -- CSS rgb() and rgba() functions
                hsl_fn = false, -- CSS hsl() and hsla() functions
                css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
                -- Available modes for `mode`: foreground, background,  virtualtext
                mode = 'background', -- Set the display mode.
                -- Available methods are false / true / "normal" / "lsp" / "both"
                -- True is same as normal
                tailwind = false, -- Enable tailwind colors
                -- parsers can contain values used in |user_default_options|
                sass = {enable = false, parsers = {'css'}}, -- Enable sass colors
                virtualtext = '■',
                -- update color values even if buffer is not focused
                -- example use: cmp_menu, cmp_docs
                always_update = false,
            },
            -- all the sub-options of filetypes apply to buftypes
            buftypes = {},
        },
    },
}
