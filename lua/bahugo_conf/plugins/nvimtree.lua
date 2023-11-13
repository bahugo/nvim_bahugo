return {
    'nvim-tree/nvim-tree.lua',
lazy=false,
config=function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require('nvim-tree').setup(
    {
   git = {
		enable = true,
        timeout = 200,
	},
}
)

    vim.keymap.set('n', '<c-n>', ':NvimTreeFindFileToggle<CR>')
end
}

