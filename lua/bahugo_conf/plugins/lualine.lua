return {
    'nvim-lualine/lualine.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        -- lsp status line
        { "SmiteshP/nvim-navic" },
    },
    config = function()
        local navic = require("nvim-navic")
        require('lualine').setup {
            options = {
                icons_enabled = true,
                -- theme = 'codedark',
                -- theme = 'rose-pine',
                theme = "auto"
            },
            sections = {
                lualine_a = {
                    {
                        'filename',
                        path = 0,
                        diagnostics_color = {
                            -- Same values as the general color option can be used here.
                            error = 'DiagnosticError', -- Changes diagnostics' error color.
                            warn  = 'DiagnosticWarn',  -- Changes diagnostics' warn color.
                            info  = 'DiagnosticInfo',  -- Changes diagnostics' info color.
                            hint  = 'DiagnosticHint',  -- Changes diagnostics' hint color.
                        },
                    }
                },
                lualine_c = {
                    {
                        function()
                            return navic.get_location()
                        end,
                        cond = function()
                            return navic.is_available()
                        end
                    },
                },
            }
        }
    end
}
