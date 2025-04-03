vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {desc= "Move Down"})
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {desc= "Move Up"})

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]], {desc="Paste without registering deletion"})
-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<A-d>", [["_d]], {desc="Delete without registering deletion"})

vim.keymap.set("n", "Q", "<nop>")
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, {desc = "Format File"})

-- Better window navigation
vim.keymap.set("n", "<A-h>", "<C-w>h", {desc="Window <-"} )
vim.keymap.set("n", "<A-l>", "<C-w>l", {desc="Window ->"} )
vim.keymap.set("n", "<A-j>", "<C-w>j", {desc="Window DOWN"} )
vim.keymap.set("n", "<A-k>", "<C-w>k", {desc="Window UP"} )

vim.keymap.set("n", "<A-S-p>", "<cmd>cprev<CR>zz", {desc="Quickfix <-"})
vim.keymap.set("n", "<A-S-n>", "<cmd>cnext<CR>zz", {desc="Quickfix ->"})
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", {desc="List ->"})
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", {desc="List <-"})

vim.keymap.set("n", "<leader>rs", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>cx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Change execution rights of current file" })
