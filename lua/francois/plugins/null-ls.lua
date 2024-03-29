-- we need to configure formatters and linters separately
-- from lsp servers
local setup, null_ls = pcall(require, "null-ls")
if not setup then
	return
end

local mason_null_ls_setup, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_setup then
	return
end

local formatting = null_ls.builtins.formatting
-- use diagnostics from null-ls when needed
-- local diagnostics = null_ls.builtins.diagnostics
-- local actions = null_ls.builtins.code_actions

-- to setup format on save
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
	sources = {
		formatting.stylua,
		formatting.rustfmt,
		formatting.prettier.with({
			extra_filetypes = { "vue", "svelte" },
		}),
	},
	-- configure format on save
	on_attach = function(current_client, bufnr)
		if current_client.supports_method("textDocument/formatting") then
			vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
				vim.lsp.buf.format({
					bufnr = bufnr,
					filter = function(client)
						return client.name == "null-ls"
					end,
				})
				print("File formatted")
			end, { desc = "Format current buffer with LSP" })

			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({
						bufnr = bufnr,
						filter = function(client)
							return client.name == "null-ls"
						end,
					})
				end,
			})
		end
	end,
})

mason_null_ls.setup({
	ensure_installed = {},
	automatic_installation = true,
	automatic_setup = false,
})
