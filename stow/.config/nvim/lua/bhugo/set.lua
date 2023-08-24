vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.wrap = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.updatetime = 50

vim.g.mapleader = " "

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true

vim.opt.mouse=""

vim.opt.swapfile = false

-- :CWD command
-- changes the Current Working Dir to the parent folder of the currently selected file
vim.api.nvim_create_user_command('CWD', ':cd %:p:h', {})
vim.api.nvim_create_user_command('TCWD', ':tcd %:p:h', {})

vim.g.netrw_banner = 0

-- Update Sign Icons
local function lspSymbol(name, icon)
vim.fn.sign_define(
	name,
	{ text = icon, numhl = name }
)
end

lspSymbol("DiagnosticSignError", "")
lspSymbol("DiagnosticSignInformation", "")
lspSymbol("DiagnosticSignHint", "")
lspSymbol("DiagnosticSignInfo", "")
lspSymbol("DiagnosticSignWarning", "")
lspSymbol("DiagnosticSignWarn", "")
