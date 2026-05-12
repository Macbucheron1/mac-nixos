vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local spec = ev.data and ev.data.spec
    local path = ev.data and ev.data.path
    local kind = ev.data and ev.data.kind

    if not spec or not path then
      return
    end

    if spec.name == "telescope-fzf-native.nvim"
        and (kind == "install" or kind == "update") then
      vim.notify("Compiling telescope-fzf-native.nvim...", vim.log.levels.INFO)

      vim.system({ "make" }, { cwd = path }, function(obj)
        if obj.code == 0 then
          vim.schedule(function()
            vim.notify("telescope-fzf-native.nvim compiled successfully", vim.log.levels.INFO)
          end)
        else
          vim.schedule(function()
            vim.notify(
              "Failed to compile telescope-fzf-native.nvim:\n" .. (obj.stderr or ""),
              vim.log.levels.ERROR
            )
          end)
        end
      end)
    end
  end,
})

vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  {
    src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
    name = "telescope-fzf-native.nvim",
  },
})

local telescope = require("telescope")

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
        ["<Esc>"] = "close",
      },
    },
  },

  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})

pcall(telescope.load_extension, "fzf")

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Telescope recent files" })
