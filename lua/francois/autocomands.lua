-- Highlight text on copy
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	desc = "Highlight text on yank",
	callback = function()
		vim.highlight.on_yank({ higroup = "Search", timeout = 100 })
	end,
})

-- Fix lua lsp imports
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "lua" },
	desc = "fix gf functionality inside .lua files",
	callback = function()
		---@diagnostic disable: assign-type-mismatch
		-- credit: https://github.com/sam4llis/nvim-lua-gf
		vim.opt_local.include = [[\v<((do|load)file|require|reload)[^''"]*[''"]\zs[^''"]+]]
		vim.opt_local.includeexpr = "substitute(v:fname,'\\.','/','g')"
		vim.opt_local.suffixesadd:prepend(".lua")
		vim.opt_local.suffixesadd:prepend("init.lua")

		for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
			vim.opt_local.path:append(path .. "/lua")
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"qf",
		"help",
		"man",
		"floaterm",
		"lspinfo",
		"lir",
		"lsp-installer",
		"null-ls-info",
		"tsplayground",
		"DressingSelect",
		"Jaq",
	},
	callback = function()
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true })
		vim.opt_local.buflisted = false
	end,
})
