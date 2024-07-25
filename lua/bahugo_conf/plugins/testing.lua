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

    keys = {
        {"<leader>t", "", desc = "+test"},
        { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
        { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Test Files" },
        { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest" },
        { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run Last" },
        { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
        { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
        { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
        { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
        { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle Watch" },
        { "<leader>td", function() require("neotest").run.run({strategy = "dap"}) end, desc = "Debug Nearest" },
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
                  -- pytest_discover_instances = true,
                }),
                -- require('rustaceanvim.neotest'),
                require("neotest-plenary"),
            }
        })
    end
}
