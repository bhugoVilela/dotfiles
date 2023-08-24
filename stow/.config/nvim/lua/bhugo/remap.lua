vim.g.mapleader = " "
vim.keymap.set("n", "<leader>ex", vim.cmd.Ex)
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Move lines up and down
--vim.keymap.set("n", "<C-j>", ":m .+1<CR>==")
--vim.keymap.set("n", "<C-k>", ":m .-2<CR>==")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- cursor stays in place J'ing
vim.keymap.set("n", "J", "mzJ`z")

-- half page move
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- search term in middle of screen
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- paste on top of selection without losing current clipboard
vim.keymap.set("x", "<leader>p", "\"_dP")

-- yank to system clipboard
vim.keymap.set("n", "<leader>y", "\"*y")
vim.keymap.set("v", "<leader>y", "\"*y")
vim.keymap.set("n", "<leader>Y", "\"*Y")

vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")
vim.keymap.set("n", "<leader>f", function()
	vim.lsp.buf.format()
end)
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

vim.keymap.set("t", "jk", "<C-\\><C-n>")
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("i", "<Esc>", "<Nop>")

vim.keymap.set("n", "<C-p>", "<C-^>")

vim.keymap.set("x", ".", ":normal .<cr>")

vim.keymap.set("n", "<leader>w", ":w<cr>")

vim.keymap.set("n", "<C-w>e", "20<C-w>>")
vim.keymap.set("n", "<C-w>E", "20<C-w><")

vim.keymap.set("n", "<leader>u", ":UndotreeToggle<cr>")
