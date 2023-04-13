-- This is your opts table
require("telescope").setup {
    extensions = {
            -- utilisation de ui select pour afficher les code actions dans telescope
            ["ui-select"] = {
            require("telescope.themes").get_dropdown {
                -- even more opts
            },
            codeactions = true,
        }
    }
}
-- To get ui-select loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("ui-select")
require('telescope').load_extension('dap')
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = "Telescope git_files" })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sc', require('telescope').extensions.neoclip.default, { desc = '[S]earch [C]lipboard' })
vim.keymap.set('n', '<leader>dc', require('telescope').extensions.dap.commands, { desc = '[D]ap [C]ommands' })
vim.keymap.set('n', '<leader>dg', require('telescope').extensions.dap.configurations, { desc = '[D]ap confi[G]urations' })
