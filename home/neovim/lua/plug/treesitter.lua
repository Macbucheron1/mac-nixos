vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

require('nvim-treesitter').install { 
	"bash",
	"git_config",
	"git_rebase",
	"gitattributes",
	"gitcommit",
	"gitignore",
	"go",
	"gomod",
	"gosum",
	"json",
	"toml",
	"yaml",
	"lua",
	"make",
	"markdown",
	"python",
	"zig",
	"vim",
	"vimdoc",
}

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})
