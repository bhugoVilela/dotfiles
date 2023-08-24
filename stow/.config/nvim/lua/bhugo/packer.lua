-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.1',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}

	use { 'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons' }

	-- Themes
	use({ 'rose-pine/neovim', as = 'rose-pine' })
	use('rmehri01/onenord.nvim')
	use('Shatur/neovim-ayu')
	use("rebelot/kanagawa.nvim")
	use 'loctvl842/monokai-pro.nvim'
	use { "catppuccin/nvim", as = "catppuccin" }
	use { "folke/tokyonight.nvim", }

	use { "akinsho/toggleterm.nvim", tag = '*' }
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'nvim-tree/nvim-web-devicons' }
	}
	use {
		'filipdutescu/renamer.nvim',
		branch = 'master',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}
	use 'ThePrimeagen/vim-be-good'

	use({
		"kylechui/nvim-surround",
		tag = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end
	})

	-- use({
	-- 	"lmburns/lf.nvim",
	-- 	requires = { "plenary.nvim", "toggleterm.nvim" }
	-- })



	use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
	use('theprimeagen/harpoon')
	use('tpope/vim-fugitive')
	use { "tpope/vim-vinegar" }
	use('ggandor/leap.nvim')
	--use('m4xshen/autoclose.nvim')
	use('windwp/nvim-autopairs')
	use('windwp/nvim-ts-autotag')
	use('terrortylor/nvim-comment')
	use "lukas-reineke/indent-blankline.nvim"
	use { "beauwilliams/focus.nvim", config = function() require("focus").setup() end }
	use {
		'nvim-tree/nvim-tree.lua',
		requires = {
			'nvim-tree/nvim-web-devicons', -- optional
		},
		config = function()
			require("nvim-tree").setup {}
		end
	}
	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v2.x',
		requires = {
			-- LSP Support
			{ 'neovim/nvim-lspconfig' }, -- Required
			{
				-- Optional
				'williamboman/mason.nvim',
				run = function()
					pcall(vim.cmd, 'MasonUpdate')
				end,
			},
			{ 'williamboman/mason-lspconfig.nvim' }, -- Optional

			-- Autocompletion
			{ 'hrsh7th/nvim-cmp' }, -- Required
			{ 'hrsh7th/cmp-nvim-lsp' }, -- Required
			{ 'L3MON4D3/LuaSnip' }, -- Required
		}
	}

	-- Markdown preview
	use({
		"iamcco/markdown-preview.nvim",
		run = function() vim.fn["mkdp#util#install"]() end,
	})

	use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install",
		setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })

	use 'mbbill/undotree'
end)
