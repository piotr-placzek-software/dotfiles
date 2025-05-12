return {
  "stevearc/conform.nvim",
  debug = true,
  event = { "BufReadPre", "BufWritePre" },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      css = { "prettierd" },
      html = { "prettierd" },
      json = { "prettierd" },
      javascript = { "eslint_d", "prettierd" },
      typescript = { "eslint_d", "prettierd" },
    },
    format_after_save = {
      lsp_format = "fallback",
    },
  },
}
