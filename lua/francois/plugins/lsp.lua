local lsp_setup, lsp = pcall(require, "lsp-zero")
if not lsp_setup then
	return
end

local saga_setup, lsp_saga = pcall(require, "lspsaga")
if not saga_setup then
	return
end

local neodev_setup, neodev = pcall(require, "neodev")
if not neodev_setup then
	return
end

local luasnip_setup, luasnip = pcall(require, "luasnip")
if not luasnip_setup then
	return
end

local mason_setup, mason = pcall(require, "mason")
if not mason_setup then
	return
end

local lspconfig_setup, lspconfig = pcall(require, "mason-lspconfig")
if not lspconfig_setup then
	return
end

-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
neodev.setup({})

lsp.preset({})

mason.setup({})
lspconfig.setup({
	ensure_installed = {
		"tsserver",
		"html",
		"cssls",
		"eslint",
		"lua_ls",
		"jsonls",
		"bashls",
		"rust_analyzer",
	},
	handlers = {
		lsp.default_setup,
	},
})

-- Fix Undefined global 'vim'
lsp.configure("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

lsp.configure("tsserver", {
	single_file_support = false,
	init_options = {
		hostInfo = "neovim",
		plugins = {
			{
				name = "typescript-svelte-plugin",
				location = "/home/francois/.local/share/pnpm/global/5/node_modules/",
			},
		},
	},
})

lsp.configure("rust_analyzer", {
	settings = {
		["rust-analyzer"] = {
			cargo = {
				features = "all",
			},
			procMacro = {
				enable = true,
			},
			checkOnSave = {
				command = "clippy",
			},
		},
	},
})

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
	-- Enter to select completion item and close cmp
	["<CR>"] = cmp.mapping.confirm({
		behavior = cmp.ConfirmBehavior.Replace,
		select = true,
	}),
	["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
	["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
	-- toggle completion
	["<C-Space>"] = cmp.mapping(function()
		if cmp.visible() then
			cmp.close()
		else
			cmp.complete()
		end
	end),
})

lsp.set_preferences({
	set_lsp_keymaps = false,
	sign_icons = {},
})

-- disable completion with tab
-- this helps with copilot setup
cmp_mappings["<Tab>"] = nil
cmp_mappings["<S-Tab>"] = nil

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	},
	mapping = cmp_mappings,
})

lsp.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false, silent = true }

	-- default keymaps for lsp
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)

	if client.name == "eslint" then
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = { "*.tsx", "*.ts", "*.jsx", "*.js" },
			command = "silent! EslintFixAll",
			group = vim.api.nvim_create_augroup("MyAutocmdsJavaScripFormatting", {}),
			desc = "Run eslint when saving buffer.",
		})
	end
end)

lsp.setup()

-- setup default vim diagnostics
-- we want to see the errors in virtual text
vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	update_in_insert = false,
	underline = true,
	severity_sort = false,
	float = true,
})

lsp_saga.setup()
