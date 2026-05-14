vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.nvim" },
})

-- Better Around/Inside textobjects
require("mini.ai").setup({ n_lines = 500 })
	
require("mini.move").setup({
	mappings = {
		-- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
		left = "<M-h>",
		right = "<M-l>",
		down = "<M-j>",
		up = "<M-k>",

		-- Move current line in Normal mode
    line_left = "<M-h>",
    line_right = "<M-l>",
    line_down = "<M-j>",
    line_up = "<M-k>",
	},

-- Options which control moving behavior
	options = {
		-- Automatically reindent selection during linewise vertical move
		reindent_linewise = false,
	},
})

if vim.g.have_nerd_font then
	require("mini.icons").setup()
end

require('mini.base16').setup({
  palette = {
    base00 = '#282828', base01 = '#3c3836', base02 = '#504945', base03 = '#665c54',
    base04 = '#bdae93', base05 = '#d5c4a1', base06 = '#ebdbb2', base07 = '#fbf1c7',
    base08 = '#fb4934', base09 = '#fe8019', base0A = '#fabd2f', base0B = '#b8bb26',
    base0C = '#8ec07c', base0D = '#83a598', base0E = '#d3869b', base0F = '#d65d0e'
  }
})
