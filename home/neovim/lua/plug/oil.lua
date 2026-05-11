vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.icons" },
})

vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
})

require("oil").setup({
	default_file_explorer = true,
	columns = {
		"icon",
		-- "permissions",
		-- "size",
	},
	constrain_cursor = "editable",
	skip_confirm_for_simple_edits = true,
	view_options = {
		show_hidden = true,
	},
	watch_for_changes = true
})
