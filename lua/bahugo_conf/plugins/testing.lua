return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-neotest/neotest-python",
    "nvim-neotest/neotest-plenary",
    "nvim-neotest/neotest-vim-test",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter"
    },
    config = function()
    require("neotest").setup(
        {
            adapters = {
                require("neotest-python")({
                  -- Extra arguments for nvim-dap configuration
                  -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
                  dap = { justMyCode = false },
                  -- Command line arguments for runner
                  -- Can also be a function to return dynamic values
                  args = {"--log-level", "DEBUG"},
                  -- Runner to use. Will use pytest if available by default.
                  -- Can be a function to return dynamic value.
                  runner = "pytest",
                  python = "python",
                  pytest_discover_instances = true,
                }),
                require('rustaceanvim.neotest'),
                require("neotest-plenary"),
            }
        })
    end
}
