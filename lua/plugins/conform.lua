return {
  "stevearc/conform.nvim",
  opts = {
    format_on_save = {
      timeout_ms = 2000,
      lsp_fallback = false, -- important: don't fall back to LSP formatting
    },
    formatters_by_ft = {
      javascript = { "prettierd" },
      javascriptreact = { "prettierd" },
      typescript = { "prettierd" },
      typescriptreact = { "prettierd" },
      markdown = { "prettierd" },
      css = { "prettierd" },
      html = { "prettierd" },
      rust = { "rustfmt" },
      yaml = { "prettierd" }
    },
  },
}

