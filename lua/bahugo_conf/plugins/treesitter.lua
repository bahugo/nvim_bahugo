return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies={
        'nvim-treesitter/nvim-treesitter-textobjects',
        -- 'nvim-treesitter/playground',
    },
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        ensure_installed = { "qmldir", "qmljs", "cpp", "c_sharp", "python", "c",
                "lua", "luadoc", "rust", "sql", "yaml", "csv", "xml", "bash", "fortran", "cmake", "json",
                "rst", "toml", "html", "markdown", "markdown_inline", "comment", "git_config", "gitcommit",
                "gitignore", "regex", "latex", "fish", "doxygen", "dockerfile", "diff", "kdl"
            },
        highlight = { enable = true },
        indent = { enable = true },
      })

        vim.treesitter.language.register("qmljs", "qml")
        vim.treesitter.language.register("python", "aster")
    end
  },

}

