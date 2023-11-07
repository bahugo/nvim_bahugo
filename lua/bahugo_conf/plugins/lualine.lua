return {
    'nvim-lualine/lualine.nvim',
    config = function()
        require('lualine').setup {
            options = {
                icons_enabled = false,
                -- theme = 'codedark',
                -- theme = 'rose-pine',
                theme = "auto"
            },
            sections = {
                lualine_a = {
                    {
                        'filename',
                        path = 1,
                    }
                }
            }
        }
    end
}
