function IDE()
	-- tab 1
	vim.cmd('vsp')
	vim.cmd(':term')
	vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-w>l',true,true,true))
	vim.cmd(':term')

	-- tab 2
	vim.cmd(':tabnew')
	vim.cmd(':tcd ~/code/homemd-web')

	-- tab 3
	vim.cmd(':tabnew')
	vim.cmd(':tcd ~/code/homemd-server')
end

