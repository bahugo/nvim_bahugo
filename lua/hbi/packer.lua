-- This file can be loaded by calling `lua require('plugins')` from your init.vim

local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        print("clonage de packer.nvim dans " .. install_path)
        fn.system({'git', 'clone', '--depth', '1',
        'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()


return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.0',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }
  use { "catppuccin/nvim",
  as = "catppuccin",
  config = function ()
      vim.cmd('colorscheme catppuccin')
  end
  }
  use({
      'rose-pine/neovim',
      as = 'rose-pine',
      -- config = function()
      --     vim.cmd('colorscheme rose-pine')
      -- end
  })
  use {
      "folke/which-key.nvim",
      config = function()
          require("which-key").setup {
              -- your configuration comes here
              -- or leave it empty to use the default settings
              -- refer to the configuration section below
          }
      end
  }
  use {
      -- Highlight, edit, and navigate code
      'nvim-treesitter/nvim-treesitter',
      run = function()
          pcall(require('nvim-treesitter.install').update { with_sync = true })
      end,
  }
  use {
      -- Additional text objects via treesitter
      'nvim-treesitter/nvim-treesitter-textobjects',
      after = 'nvim-treesitter',
  }
  use('nvim-treesitter/playground')
  use('theprimeagen/harpoon')
  use('mbbill/undotree')
  use {"akinsho/toggleterm.nvim", tag = '*',
  config = function()
      require("toggleterm").setup()
  end}
  -- git
  use {'lewis6991/gitsigns.nvim'}
  use('tpope/vim-fugitive')
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
  use 'nvim-lualine/lualine.nvim'
  -- ampoule avec action disponibles
  use {"kosayoda/nvim-lightbulb",
  requires = "antoinemadec/FixCursorHold.nvim"}

  use 'nvim-tree/nvim-tree.lua'
  use {
	  'neovim/nvim-lspconfig',
	  requires = {
		  -- LSP Support
		  {'williamboman/mason.nvim'},
		  {'williamboman/mason-lspconfig.nvim'},

		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},
		  {'hrsh7th/cmp-buffer'},
		  {'hrsh7th/cmp-path'},
		  {'saadparwaiz1/cmp_luasnip'},
		  {'hrsh7th/cmp-nvim-lsp'},
		  {'hrsh7th/cmp-nvim-lua'},

		  -- Snippets
		  {'L3MON4D3/LuaSnip'},
		  {'rafamadriz/friendly-snippets'},
          -- Useful status Update for LSP
          {'j-hui/fidget.nvim'},
          -- Additional lua configuration for nvim
          {'folke/neodev.nvim'}
	  }
  }
  -- fenetre d'affichage de la structure des fonctions et classes du fichier ouvert
  use "preservim/tagbar"
  -- debugger
  use 'mfussenegger/nvim-dap'
  use 'mfussenegger/nvim-dap-python'

  -- zen mode
  use("folke/zen-mode.nvim")

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
      require('packer').sync()
  end
end)

