return {
    'theprimeagen/harpoon',
    branch="harpoon2",
    config = function()
        local harpoon = require("harpoon")
        -- REQUIRED
        harpoon:setup()
        -- REQUIRED

        vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end, { desc = "Harpoon - add file" } )
        vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon - toggle" })

        vim.keymap.set("n", "<C-h>", function() harpoon:list():next({ui_nav_wrap=true}) end, { desc = "Harpoon - cycle ->" })
        vim.keymap.set("n", "<C-y>", function() harpoon:list():prev({ui_nav_wrap=true}) end, { desc = "Harpoon - cycle <-" })
    end
}
