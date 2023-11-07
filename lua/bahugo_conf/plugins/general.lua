return {

    {
        "AckslD/nvim-neoclip.lua",
        'nvim-telescope/telescope-ui-select.nvim',
        dependencies = {
            { 'nvim-telescope/telescope.nvim' },
        },
        config = function()
            require('neoclip').setup()
        end,
    },
    {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    },
    {
        'mbbill/undotree',
        config = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end
    },
    -- ampoule avec action disponibles
    {
        "kosayoda/nvim-lightbulb",
        dependencies = "antoinemadec/FixCursorHold.nvim"
    },

    {
        -- plugin pour la gestion des dépendances rust
        'saecki/crates.nvim',
        -- lazyloading
        event = { "BufRead Cargo.toml" },
        config = function()
            require("crates").setup()
        end,
    },
    -- fenetre d'affichage de la structure des fonctions et classes du fichier ouvert
    {
        "liuchengxu/vista.vim",
        config = function()
            vim.g.vista_default_executive = 'nvim_lsp'
        end
    },
}
