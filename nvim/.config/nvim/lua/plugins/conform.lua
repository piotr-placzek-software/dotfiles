return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufWritePre" },
  opts = require "configs.conform",
}
