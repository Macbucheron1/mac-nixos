vim.pack.add({
  "https://github.com/mason-org/mason-lspconfig.nvim",
})

require("mason-lspconfig").setup{
  ensure_installed = { "gopls" }
}
