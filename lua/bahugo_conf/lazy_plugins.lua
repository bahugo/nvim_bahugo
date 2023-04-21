return {
    -- Packer can manage itself
    'wbthomason/packer.nvim',

    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = { { 'nvim-lua/plenary.nvim' } }
    },
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
        "catppuccin/nvim",
        name = "catppuccin",
        config = function()
            vim.cmd('colorscheme catppuccin')
        end
    },
    ({
        'rose-pine/neovim',
        name = 'rose-pine',
        -- config = function()
        --     vim.cmd('colorscheme rose-pine')
        -- end
    }),
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
        "folke/trouble.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("trouble").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    },
    {
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        run = function()
            pcall(require('nvim-treesitter.install').update { with_sync = true })
        end,
    },
    {
        -- Additional text objects via treesitter
        'nvim-treesitter/nvim-treesitter-textobjects',
        -- after = 'nvim-treesitter',
    },
    ('nvim-treesitter/playground'),
    ('theprimeagen/harpoon'),
    ('mbbill/undotree'),
    {
        "akinsho/toggleterm.nvim",
        version = '*',
        config = function()
            require("toggleterm").setup()
        end
    },
    -- git
    { 'lewis6991/gitsigns.nvim' },
    ('tpope/vim-fugitive'),
    'numToStr/Comment.nvim', -- "gc" to comment visual regions/lines
    'nvim-lualine/lualine.nvim',
    -- ampoule avec action disponibles
    {
        "kosayoda/nvim-lightbulb",
        dependencies = "antoinemadec/FixCursorHold.nvim"
    },

    'nvim-tree/nvim-tree.lua',
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            -- LSP Support
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
            -- Useful status Update for LSP
            { 'j-hui/fidget.nvim' },
            -- Additional lua configuration for nvim
            { 'folke/neodev.nvim' }
        }
    },
    {
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-treesitter/nvim-treesitter" }
        }
    },
    {
        "simrat39/rust-tools.nvim",
        dependencies = {
            'neovim/nvim-lspconfig',
            "mfussenegger/nvim-dap",
        }
    },
    {
        -- plugin pour la gestion des dépendances rust
        'saecki/crates.nvim',
        -- lazyloading
        event = { "BufRead Cargo.toml" },
        config= function ()
            require("crates").setup()
        end,
    },
    -- fenetre d'affichage de la structure des fonctions et classes du fichier ouvert
    "liuchengxu/vista.vim",
    -- Debugging
    {
        "mfussenegger/nvim-dap",
        -- wants = { "nvim-dap-virtual-text", "nvim-dap-ui", "nvim-dap-python",
        --     "which-key.nvim" },
        dependencies = {
            "williamboman/mason.nvim",
            "theHamsta/nvim-dap-virtual-text",
            "rcarriga/nvim-dap-ui",
            "mfussenegger/nvim-dap-python",
            "nvim-telescope/telescope-dap.nvim",
            "jbyuki/one-small-step-for-vimkind",
        },
    },
    -- zen mode
    ("folke/zen-mode.nvim"),
}
