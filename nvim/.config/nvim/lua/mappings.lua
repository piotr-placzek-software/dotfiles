require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map(
  "n",
  "fr",
  "<cmd>Telescope lsp_references<CR>",
  { desc = "Find references (telescope)", noremap = true, silent = true }
)
