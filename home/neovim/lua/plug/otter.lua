vim.pack.add({
	{ src = "https://github.com/jmbuhr/otter.nvim" },
})

local otter = require("otter")
otter.setup()

vim.keymap.set("n", "<leader>e", function()
	otter.activate()
end)
