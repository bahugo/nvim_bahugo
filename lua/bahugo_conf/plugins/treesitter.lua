return {
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
            -- 'nvim-treesitter/playground',
        },
        build = ":TSUpdate",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local config = require("nvim-treesitter.configs")
            config.setup({
                ensure_installed = { "qmldir", "qmljs", "cpp", "c_sharp", "python", "c", "astro",
                    "html", "javascript", "typescript", "jsdoc", "lua", "luadoc", "rust", "sql",
                    "yaml", "csv", "xml", "bash", "fortran", "cmake", "json", "rst", "toml",
                    "markdown", "markdown_inline", "comment", "ssh_config",
                    "git_config", "gitcommit", "gitattributes", "gitignore",
                    "regex", "fish", "doxygen", "dockerfile", "diff", "kdl",
                    -- latex requires tree-sitter cli to be installed
                    -- "latex",
                },
                highlight = { enable = true },
                indent = { enable = true },
            })

            vim.treesitter.language.register("qmljs", "qml")
            vim.treesitter.language.register("python", "aster")
        end
    },

}
