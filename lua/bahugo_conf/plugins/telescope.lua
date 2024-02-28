local telescope = require('telescope')
local telescope_builtin = require('telescope.builtin')
return {

    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { { 'nvim-lua/plenary.nvim' } },
    keys={

        {mode= 'n', '<C-p>',      function() telescope_builtin.git_files() end,  desc = "Telescope git_files" },
        {mode= 'n', '<leader>sf', function() telescope_builtin.find_files() end,  desc = '[S]earch [F]iles' },
        {mode= 'n', '<leader>sh', function() telescope_builtin.help_tags() end,  desc = '[S]earch [H]elp' },
        {mode= 'n', '<leader>sw', function() telescope_builtin.grep_string() end,  desc = '[S]earch current [W]ord' },
        {mode= 'n', '<leader>sg', function() telescope_builtin.live_grep() end,  desc = '[S]earch by [G]rep' },
        {mode= 'n', '<leader>sd', function() telescope_builtin.diagnostics({bufnr=0}) end,  desc = '[S]earch [D]iagnostics in current buffer' },
        {mode= 'n', '<leader>sc', function() telescope.extensions.neoclip.default() end,  desc = '[S]earch [C]lipboard' },
        {mode= 'n', '<leader>dc', function() telescope.extensions.dap.commands() end,  desc = '[D]ap [C]ommands' },
        {mode= 'n', '<leader>dg', function() telescope.extensions.dap.configurations() end,  desc = '[D]ap confi[G]urations' },
    },
    config = function()
        -- This is your opts table
        telescope.setup {
            path_display="smart",
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
        telescope.load_extension("ui-select")
        telescope.load_extension('dap')
    end
}
