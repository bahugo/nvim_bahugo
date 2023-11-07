return {

    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { { 'nvim-lua/plenary.nvim' } },
    keys={

        {mode= 'n', '<C-p>',      function() require('telescope.builtin').git_files() end,  desc = "Telescope git_files" },
        {mode= 'n', '<leader>sf', function() require('telescope.builtin').find_files() end,  desc = '[S]earch [F]iles' },
        {mode= 'n', '<leader>sh', function() require('telescope.builtin').help_tags() end,  desc = '[S]earch [H]elp' },
        {mode= 'n', '<leader>sw', function() require('telescope.builtin').grep_string() end,  desc = '[S]earch current [W]ord' },
        {mode= 'n', '<leader>sg', function() require('telescope.builtin').live_grep() end,  desc = '[S]earch by [G]rep' },
        {mode= 'n', '<leader>sd', function() require('telescope.builtin').diagnostics() end,  desc = '[S]earch [D]iagnostics' },
        {mode= 'n', '<leader>sc', function() require('telescope').extensions.neoclip.default() end,  desc = '[S]earch [C]lipboard' },
        {mode= 'n', '<leader>dc', function() require('telescope').extensions.dap.commands() end,  desc = '[D]ap [C]ommands' },
        {mode= 'n', '<leader>dg', function() require('telescope').extensions.dap.configurations() end,  desc = '[D]ap confi[G]urations' },
    },
    config = function()
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
    end
}
