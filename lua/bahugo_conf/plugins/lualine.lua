return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
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

                lualine_c = { function()
                    return vim.fn['nvim_treesitter#statusline']({
                        indicator_size = 90,
                        type_patterns = { 'class',},
                        separator = ' -> ',
                    })
                end }
            }
        }
    end
}
