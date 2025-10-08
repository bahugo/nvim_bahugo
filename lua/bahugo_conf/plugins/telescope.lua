local telescope = require('telescope')
local telescope_builtin = require('telescope.builtin')
local config = require('telescope.config')

-- Return a list of files found in quickfix, skipping duplicates
local quickfix_files = function()
    local qflist = vim.fn.getqflist()
    local files = {}
    local seen = {}
    for k in pairs(qflist) do
        local path = vim.fn.bufname(qflist[k]["bufnr"])
        if not seen[path] then
            files[#files + 1] = path
            seen[path] = true
        end
    end
    table.sort(files)
    return files
end

-- Invoke live_grep on all files in quickfix
local grep_on_quickfix = function()
    local args = {}

    for _, v in ipairs(config.values.vimgrep_arguments) do
        args[#args + 1] = v
    end
    for _, path in ipairs(quickfix_files()) do
        args[#args + 1] = '-g/' .. path
        vim.notify(string.format("Found %s ", path), vim.log.levels["INFO"], {})
    end
    for _, v in ipairs(args) do
        vim.notify(v, vim.log.levels["INFO"], {})
    end

    telescope_builtin.live_grep({ vimgrep_arguments = args })
end

return {

    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { { 'nvim-lua/plenary.nvim' } },
    keys = {

        { mode = 'n', '<C-p>',      function() telescope_builtin.git_files() end,                desc = "Telescope git_files" },
        { mode = 'n', '<leader>sf', function() telescope_builtin.find_files() end,               desc = '[S]earch [F]iles' },
        { mode = 'n', '<leader>sh', function() telescope_builtin.help_tags() end,                desc = '[S]earch [H]elp' },
        { mode = 'n', '<leader>sw', function() telescope_builtin.grep_string() end,              desc = '[S]earch current [W]ord' },
        { mode = 'n', '<leader>sg', function() telescope_builtin.live_grep() end,                desc = '[S]earch by [G]rep' },
        { mode = 'n', '<leader>sd', function() telescope_builtin.diagnostics({ bufnr = 0 }) end, desc = '[S]earch [D]iagnostics in current buffer' },
        { mode = 'n', '<leader>sc', function() telescope.extensions.neoclip.default() end,       desc = '[S]earch [C]lipboard' },
        { mode = 'n', '<leader>sq', grep_on_quickfix,                                            desc = "[S]earch in [Q]uickfix files" },
        { mode = 'n', '<leader>dc', function() telescope.extensions.dap.commands() end,          desc = '[D]ap [C]ommands' },
        { mode = 'n', '<leader>dg', function() telescope.extensions.dap.configurations() end,    desc = '[D]ap confi[G]urations' },
    },
    config = function()
        -- This is your opts table
        telescope.setup({
            path_display = "smart",
            extensions = {
                -- utilisation de ui select pour afficher les code actions dans telescope
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown {
                        -- even more opts
                    },
                    codeactions = true,
                }
            }
        })
        -- To get ui-select loaded and working with telescope, you need to call
        -- load_extension, somewhere after setup function:
        telescope.load_extension("ui-select")
        telescope.load_extension('dap')
    end
}
