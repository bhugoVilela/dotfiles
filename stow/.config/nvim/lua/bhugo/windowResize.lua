local function Vres(amount)
	vim.cmd("res " .. amount)
end

local function Hres(amount)
	vim.cmd("vertical res " .. amount)
end

-- Set window horizontal width
vim.keymap.set("n", "<leader>wh", function()
	local amount = vim.fn.input("width: ")
	Hres(amount)
end)

-- set window vertical height
vim.keymap.set("n", "<leader>wv", function()
	local amount = vim.fn.input("height: ")
	Vres(amount)
end)
