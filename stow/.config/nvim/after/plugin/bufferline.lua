local bline = require('bufferline')
bline.setup {
	options = {
		close_command = "Bdelete %d",
		numbers = "buffer_id",
		indicator = {
			icon = "> ",
			style = "icon"
		},
		show_buffer_close_icons = false,
		separator_style = { '|', '|' },
		offsets = {{ filetype = "NvimTree", text = ""}},
	}
}
vim.keymap.set('n', "L", function()
	bline.cycle(1)
end)
vim.keymap.set('n', "H", function()
	bline.cycle(-1)
end)
vim.keymap.set('n', "X", function()
	vim.cmd"bd"
end)
