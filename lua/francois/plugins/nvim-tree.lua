local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then
	return
end

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- empty setup using defaults
nvimtree.setup({
	update_focused_file = {
		enable = true,
	},
	renderer = {
		indent_markers = {
			enable = false,
			icons = {
				corner = "└",
				edge = "│",
				item = "│",
				none = " ",
			},
		},
		icons = {
			show = {
				file = true,
				folder = true,
				folder_arrow = true,
				git = false,
			},
		},
		highlight_git = true,
		group_empty = false,
		root_folder_modifier = ":t",
	},
	filters = {
		dotfiles = false,
		custom = { "node_modules", "\\.cache" },
		exclude = {},
	},
	trash = {
		cmd = "trash",
		require_confirm = true,
	},
	log = {
		enable = false,
		truncate = false,
		types = {
			all = false,
			config = false,
			copy_paste = false,
			diagnostics = false,
			git = false,
			profile = false,
		},
	},
	actions = {
		use_system_clipboard = true,
		change_dir = {
			enable = true,
			global = false,
			restrict_above_cwd = false,
		},
		open_file = {
			quit_on_open = false,
			resize_window = false,
			window_picker = {
				enable = true,
				chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
				exclude = {
					filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
					buftype = { "nofile", "terminal", "help" },
				},
			},
		},
	},
})
