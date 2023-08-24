local Themes = {
	{
		'monokai-pro',
		setup = function()
			require('monokai-pro').setup {
				filter = 'octagon'
			}
		end
	},
	{ 'onenord' },
	{ 'ayu-dark' },
	{ 'ayu-light' },
	{ 'catppuccin', config = function()
		require('catppuccin').setup({
			flavour = 'mocha'
		})
	  end
	},
	{ 'rose-pine', setup = function()
		require('rose-pine').setup({
		})
	  end
	},
	{ 'kanagawa' },
	{ 'kanagawa-lotus' },
	{ 'tokyonight' },
	{ 'tokyonight-storm' },
	{ 'tokyonight-night' },
	{ 'tokyonight-day' },
	{ 'tokyonight-moon' }
}

local DEFAULT_LIGHT_THEME = 'ayu-light'
local DEFAULT_DARK_THEME = 'monokai-pro'

function ApplyTheme(theme, args)
	if theme.config ~= nil then
		theme.config(args)
	end

	vim.cmd.colorscheme(theme[1])
end

local function findThemeByName(name)
	if name == "dark" then
		name = "monokai-pro"
	elseif name == "light" then
		name = "ayu-light"
	end
	for key, value in pairs(Themes) do
		if value[1] == name then
			return value
		end
	end
	return nil
end


local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_set = require "telescope.actions.set"
local action_state = require "telescope.actions.state"

local function openThemePicker(args)
	local opts = require('telescope.themes').get_dropdown {}

	local themePicker = pickers.new(opts, {
		prompt_title = 'Themes',
		finder = finders.new_table {
			results = Themes,
			entry_maker = function(entry)
				return {
					value = entry,
					display = entry[1],
					ordinal = entry[1]
				}
			end
		},
		sorter = conf.generic_sorter(opts),
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				-- When theme is selected
				actions.close(prompt_bufnr)
			end)
			actions.move_selection_previous:replace(function(prompt_bufnr)
				action_set.shift_selection(prompt_bufnr, -1)
				local entry = action_state.get_selected_entry().value
				if entry ~= nil then
					ApplyTheme(entry, args)
				end
			end)
			actions.move_selection_next:replace(function(prompt_bufnr)
				action_set.shift_selection(prompt_bufnr, 1)
				local entry = action_state.get_selected_entry().value
				local entry = action_state.get_selected_entry().value
				if entry ~= nil then
					ApplyTheme(entry, args)
				end
			end)
			return true
		end
	})
	themePicker:find()
end

vim.api.nvim_create_user_command('Theme',
	function(opts)
		if opts.fargs[1] ~= nil then
			local name = opts.fargs[1]
			if name == 'light' then
				name = DEFAULT_LIGHT_THEME
			elseif name == 'dark' then
				name = DEFAULT_DARK_THEME
			end
			local theme = findThemeByName(name)
			if theme ~= nil then
				ApplyTheme(theme, { transparent_background =  true })
			end
		else
			openThemePicker({ transparent_background = true })
		end
	end,
	{
		nargs = "?",
		desc = "open Theme picker",
		complete = function()
			local newTable = {}
			for key, value in pairs(Themes) do
				newTable[key] = value[1]
			end
			return newTable
		end
	})

vim.api.nvim_create_user_command('ThemeOpaque',
	function(opts)
		if opts.fargs[1] ~= nil then
			local name = opts.fargs[1]
			if name == 'light' then
				name = DEFAULT_LIGHT_THEME
			elseif name == 'dark' then
				name = DEFAULT_DARK_THEME
			end
			local theme = findThemeByName(name)
			if theme ~= nil then
				ApplyTheme(theme, {})
			end
		else
			openThemePicker({})
		end
	end,
	{
		nargs = "?",
		desc = "open Theme picker",
		complete = function()
			local newTable = {}
			for key, value in pairs(Themes) do
				newTable[key] = value[1]
			end
			return newTable
		end
	})
ApplyTheme(findThemeByName('tokyonight'), {})

-- require("transparent").setup({
--   groups = { -- table: default groups
--     'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
--     'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
--     'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
--     'SignColumn', 'CursorLineNr', 'EndOfBuffer',
--   },
--   extra_groups = {}, -- table: additional groups that should be cleared
--   exclude_groups = {}, -- table: groups you don't want to clear
-- })
--
-- vim.cmd [[
-- 	TransparentEnable
-- ]]
