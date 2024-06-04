return {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha", -- latte, frappe, macchiato, mocha
                background = { -- :h background
                    light = "latte",
                    dark = "mocha",
                },
                transparent_background = false,
                default_integrations = true,
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                    telescope = true,
                    notify = true,
                    mini = true,
                    fidget = true,
                    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
                },
            })

            vim.cmd('colorscheme catppuccin')
        end
}
