return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  -- {
  --   "artemave/workspace-diagnostics.nvim",
  -- }
  {
    "jghauser/mkdir.nvim",
  },
  {
    "rcarriga/nvim-notify",
    configs = function()
      vim.notify = require "notify"
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      view = {
        width = 48, -- Ustawienie domyślnej szerokości
      },
    },
  },
  {
    "nvim-pack/nvim-spectre",
  },
  {
    "nvim-lua/popup.nvim",
  },
}
