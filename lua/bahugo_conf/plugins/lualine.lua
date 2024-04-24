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
                -- lualine_c = {
                --     {
                --         "navic",
                --
                --         -- Component specific options
                --         color_correction = nil, -- Can be nil, "static" or "dynamic". This option is useful only when you have highlights enabled.
                --         -- Many colorschemes don't define same backgroud for nvim-navic as their lualine statusline backgroud.
                --         -- Setting it to "static" will perform a adjustment once when the component is being setup. This should
                --         --   be enough when the lualine section isn't changing colors based on the mode.
                --         -- Setting it to "dynamic" will keep updating the highlights according to the current modes colors for
                --         --   the current section.
                --
                --         navic_opts = nil -- lua table with same format as setup's option. All options except "lsp" options take effect when set here.
                --     }
                -- },
                -- lualine_c = { function()
                --     return vim.fn['nvim_treesitter#statusline']({
                --         indicator_size = 90,
                --         type_patterns = { 'class',},
                --         separator = ' -> ',
                --     })
                -- end }
            }
        }
    end
}
