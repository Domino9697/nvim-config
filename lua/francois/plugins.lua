local ensure_lazy = function()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	local uv = vim.uv or vim.loop

	-- Auto-install lazy.nvim if not present
	if not uv.fs_stat(lazypath) then
		print("Installing lazy.nvim....")
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable", -- latest stable release
			lazypath,
		})
	end

	vim.opt.rtp:prepend(lazypath)
end

ensure_lazy()

local status, lazy = pcall(require, "lazy")
if not status then
	return
end

return lazy.setup({
	{ "rebelot/kanagawa.nvim" },

	-- fuzzy finding
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		config = function()
			require("francois.plugins.telescope")
		end,
	},

	{ "folke/tokyonight.nvim" },

	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons", -- optional, for file icons
		},
		config = function()
			require("francois.plugins.nvim-tree")
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("francois.plugins.treesitter")
		end,
	},

	{
		"mbbill/undotree",

		config = function()
			require("francois.plugins.undotree")
		end,
	},

	-- Surround motions with stuff
	{ "tpope/vim-surround" },

	-- Comment with GC
	{
		"numToStr/Comment.nvim",
		config = function()
			require("francois.plugins.comment")
		end,
	},

	-- lualine status
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("francois.plugins.lualine")
		end,
	},

	-- lsp
	{
		"VonHeikemen/lsp-zero.nvim",
		version = "v3.x",
		dependencies = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },

			-- Snippets
			{ "L3MON4D3/LuaSnip", version = "v2.*" },
			{ "rafamadriz/friendly-snippets" },
		},
		config = function()
			require("francois.plugins.lsp")
		end,
	},
	-- lsp progress status
	{
		"j-hui/fidget.nvim",

		config = function()
			require("francois.plugins.fidget")
		end,
	},

	-- lsp nice ui
	{ "glepnir/lspsaga.nvim", branch = "main" },

	-- did you forget your keymaps?
	{
		"folke/which-key.nvim",

		config = function()
			require("francois.plugins.whichkey")
		end,
	},

	-- best ai ever
	{
		"github/copilot.vim",

		config = function()
			require("francois.plugins.copilot")
		end,
	},

	-- formatting and linting
	{
		"stevearc/conform.nvim",
		config = function()
			require("francois.plugins.conform")
		end,
	},

	-- autoclosing
	{
		"windwp/nvim-autopairs",

		config = function()
			require("francois.plugins.autopairs")
		end,
	},

	{ "windwp/nvim-ts-autotag" },

	-- git
	{ "tpope/vim-fugitive" },
	{
		"lewis6991/gitsigns.nvim",

		config = function()
			require("francois.plugins.gitsigns")
		end,
	},

	-- alpha dashboard
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("alpha").setup(require("alpha.themes.startify").config)
		end,
	},

	{ -- Additional text objects via treesitter
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter" },
	},

	-- Better neovim development experience
	{ "folke/neodev.nvim" },

	-- Search and replace
	{
		"windwp/nvim-spectre",
		dependencies = { "nvim-lua/plenary.nvim" },

		config = function()
			require("francois.plugins.spectre")
		end,
	},

	-- quickfix list
	{ "kevinhwang91/nvim-bqf", ft = "qf" },
})
