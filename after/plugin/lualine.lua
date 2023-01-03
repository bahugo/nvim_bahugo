require('lualine').setup {
    option = {
        icons_enabled = true,
        theme = 'codedark',
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
