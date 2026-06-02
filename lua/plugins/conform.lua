return {
	"stevearc/conform.nvim",
	opts = {
		format_on_save = {
			timeout_ms = 3000,
			lsp_fallback = false,
		},
		formatters_by_ft = {
			javascript = { "biome", "prettierd", stop_after_first = true },
			javascriptreact = { "biome", "prettierd", stop_after_first = true },
			typescript = { "biome", "prettierd", stop_after_first = true },
			typescriptreact = { "biome", "prettierd", stop_after_first = true },
			json = { "biome", "prettierd", stop_after_first = true },
			jsonc = { "biome", "prettierd", stop_after_first = true },
			css = { "biome", "prettierd", stop_after_first = true },
			markdown = { "prettierd" },
			html = { "prettierd" },
			yaml = { "prettierd" },
			rust = { "rustfmt" },
			sql = { "pg_format" },
		},
		formatters = {
			biome = { require_cwd = true },
		},
	},
}
