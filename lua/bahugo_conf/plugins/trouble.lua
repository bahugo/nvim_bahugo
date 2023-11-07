return {

    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        require("trouble").setup {}

        vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
            { desc = "[Trouble] ", silent = true, noremap = true }
        )
        vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
            { desc = "[Trouble] workspace", silent = true, noremap = true }
        )
        vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
            { desc = "[Trouble] diagnostics", silent = true, noremap = true }
        )
        vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>",
            { desc = "[Trouble] loclist", silent = true, noremap = true }
        )
        vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
            { desc = "[Trouble] quickfix", silent = true, noremap = true }
        )
        vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
            { desc = "[Trouble] lsp_references", silent = true, noremap = true }
        )
    end
}
