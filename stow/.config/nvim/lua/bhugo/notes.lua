-- Notes in NeoVim
-- :Note <fileName>?
-- or <C-m>


local DEFAULT_FILE_NAME = 'Notes'

local function newFloat(title)
	local buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")

    local win_height = math.ceil(height * 0.8 - 4)
    local win_width = math.ceil(width * 0.8)

    local row = math.ceil((height - win_height) / 2 - 1)
    local col = math.ceil((width - win_width) / 2)

    local opts = {
        style = "minimal",
        relative = "editor",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
        border = "rounded",
		title = title,
		title_pos = "center"
    }

	local win = vim.api.nvim_open_win(buf, true, opts)
    vim.api.nvim_win_set_option(win, "cursorline", true)
	return buf
end

local function openFile(buf, file_path)
	vim.api.nvim_buf_set_option(buf, "modifiable", true)
	-- local file_path = vim.api.nvim_get_runtime_file("myPlugin/lua/catalog.txt", false)[1]
	vim.cmd(":edit " .. file_path)
	-- vim.api.nvim_command("$read" .. file_path)
    vim.api.nvim_buf_set_option(0, "modifiable", true)
	local actualBuf = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_set_keymap(actualBuf, "n", "<C-m>", ":q<CR>", {})

end

vim.api.nvim_create_user_command('Note', function(opts)
	local file = opts.args
	if file == nil or file == "" then
		file = DEFAULT_FILE_NAME
	end
	local path = "~/notes/" .. file
	local buf = newFloat(file)
	openFile(buf, path)
end, {
	nargs = "?"
})

vim.keymap.set("n", "<C-m>", ":Note<CR>")

