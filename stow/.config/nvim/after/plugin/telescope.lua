local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, {
	desc = 'find files'
})
vim.keymap.set('n', '<leader>pf', builtin.git_files, {
	desc = 'find git files'
})
vim.keymap.set('n', '<leader>pg', builtin.live_grep, {
	desc = 'project grep'
})
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, {
	desc = '[f]ind [r]eferences'
})

vim.keymap.set('n', '<leader>fb', builtin.buffers, {
	desc = '[f]ind [b]uffers'
})
vim.keymap.set('n', '<leader>fh', builtin.keymaps, {
	desc = '[f]ind [h]elp tags'
})
vim.keymap.set('n', '<leader>fsd', builtin.lsp_document_symbols, {
	desc = 'find document symbols'
})
vim.keymap.set('n', '<leader>fsw', builtin.lsp_workspace_symbols, {
	desc = 'find workspace symbols'
})

vim.keymap.set("n", "<leader>gd", builtin.lsp_definitions, opts)

vim.keymap.set("n", "<leader>fl", builtin.resume, opts)

-- require("telescope.builtin").find_files{ path_display = { "truncate" } }

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
-- local transform_mod = require('telescope.actions.mt').transform_mod

local Favorite = {
	{ "Desktop",       "~/Desktop" },
	{ "Code",          "~/code" },
	{ "Server",        "~/code/homemd-server" },
	{ "Web",           "~/code/homemd-web" },
	{ "Android",       "~/code/homemd-android" },
	{ "iOS",           "~/code/homemd-ios" },
	{ "AsyncDisplay",  "~/code/AsyncDisplay" },
	{ "NeoVim Config", "~/.config/nvim" },
	{ "Notes",         "~/notes" }
}

-- mode: 'dirs' | 'files'
local find_favorites = function(opts, mode)
	mode = mode or 'dirs'
	opts = opts or require("telescope.themes").get_dropdown {}

	local title
	if (mode == 'dirs') then
		title = 'Favorite Dirs'
	elseif mode == 'grep' then
		title = 'Grep in...'
	else
		title = 'Find Files in...'
	end

	pickers.new(opts, {
		prompt_title = title,

		finder = finders.new_table {
			results = Favorite,
			entry_maker = function(entry)
				return {
					value = entry,
					display = entry[1],
					ordinal = entry[1],
					path = entry[2]
				}
			end
		},

		sorter = conf.generic_sorter(opts),

		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				if (mode == 'dirs') then
					vim.cmd("Ex " .. selection.path)
				elseif mode == 'grep' then
					builtin.live_grep { cwd = selection.path }
				else
					builtin.find_files { cwd = selection.path }
				end
			end)
			return true
		end,
	}):find()
end

vim.keymap.set('n', '<leader>fD', function() find_favorites(nil, 'dirs') end, {
	desc = 'find favorite folders (dirs)'
})
vim.keymap.set('n', '<leader>fF', function() find_favorites(nil, 'files') end, {
	desc = 'find favorite files (dirs)'
})
vim.keymap.set('n', '<leader>pG', function() find_favorites(nil, 'grep') end, {
	desc = 'grep favorite files (grep)'
})

require('telescope').setup {
	defaults = {
		mappings = {
			i = {
				["<C-l>"] = actions.select_default,
				["<C-k>"] = actions.move_selection_previous,
				["<C-j>"] = actions.move_selection_next,
				["<C-d>"] = actions.delete_buffer,
			},
			n = {
				['jk'] = actions.close
			}
		}
	}
}
