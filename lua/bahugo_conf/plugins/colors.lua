return {
    config = function()
        require("catppuccin").setup({
            flavour = "mocha", -- latte, frappe, macchiato, mocha
            background = { -- :h background
                light = "latte",
                dark = "mocha",
            },
            transparent_background = false,
            -- show_end_of_buffer = false, -- show the '~' characters after the end of buffers
            -- term_colors = false,
            -- dim_inactive = {
            --     enabled = false,
            --     shade = "dark",
            --     percentage = 0.15,
            -- },
            -- no_italic = false, -- Force no italic
            -- no_bold = false, -- Force no bold
            -- styles = {
            --     comments = { "italic" },
            --     conditionals = { "italic" },
            --     loops = {},
            --     functions = {},
            --     keywords = {},
            --     strings = {},
            --     variables = {},
            --     numbers = {},
            --     booleans = {},
            --     properties = {},
            --     types = {},
            --     operators = {},
            -- },
            color_overrides = {
                mocha = {
                    base = "#11111b",
                    mantle = "#11111b",
                    crust = "#11111b",
                },
            },
            -- custom_highlights = {},
            integrations = {
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                telescope = true,
                notify = true,
                mini = true,
                -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
            },
        })


        require('rose-pine').setup({
            disable_background = true
        })

        function ColorMyPencils(color)
            color = color or "catppuccin"
            -- color = color or "rose-pine"
            vim.cmd.colorscheme(color)

            --    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
            -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        end

        ColorMyPencils()
    end
}
