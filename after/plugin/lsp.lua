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

-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
neodev.setup({})

lsp.preset("recommended")

lsp.ensure_installed({
	"tsserver",
	"html",
	"cssls",
	"eslint",
	"sumneko_lua",
	"jsonls",
	"bashls",
	"eslint",
})

-- Fix Undefined global 'vim'
lsp.configure("sumneko_lua", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
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

lsp.setup_nvim_cmp({
	mapping = cmp_mappings,
})

lsp.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false, silent = true }

	-- default keymaps for lsp
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)

	if client.name == "eslint" then
		local group = vim.api.nvim_create_augroup("Eslint", {})
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = group,
			pattern = "<buffer>",
			command = "EslintFixAll",
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

lsp_saga.init_lsp_saga()
