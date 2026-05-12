return {
	{
		"Yggdroot/indentLine",
	},
	{
		"ntpeters/vim-better-whitespace",
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		dependencies = { "HiPhish/rainbow-delimiters.nvim" },
		config = function()
			-- These names are shared with rainbow-delimiters so both plugins
			-- cycle through the same palette at the same nesting levels.
			local rainbow_highlights = {
				"RainbowRed",
				"RainbowYellow",
				"RainbowBlue",
				"RainbowOrange",
				"RainbowGreen",
				"RainbowViolet",
				"RainbowCyan",
			}

			local hooks = require("ibl.hooks")

			-- Re-define colors every time the colorscheme changes so they
			-- always override whatever the theme sets on these groups.
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				vim.api.nvim_set_hl(0, "RainbowRed",    { fg = "#E06C75" })
				vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
				vim.api.nvim_set_hl(0, "RainbowBlue",   { fg = "#61AFEF" })
				vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
				vim.api.nvim_set_hl(0, "RainbowGreen",  { fg = "#98C379" })
				vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
				vim.api.nvim_set_hl(0, "RainbowCyan",   { fg = "#56B6C2" })
			end)

			require("ibl").setup({
				indent = {
					char = "│",
					tab_char = "│",
					highlight = rainbow_highlights,
				},
				scope = {
					enabled = true,
					show_start = true,
					show_end = true,
					highlight = rainbow_highlights,
				},
				exclude = {
					filetypes = {
						"help", "alpha", "dashboard", "neo-tree",
						"Trouble", "lazy", "mason", "notify",
						"toggleterm", "TelescopePrompt", "TelescopeResults",
					},
				},
			})

			-- Each scope underline takes its color from the rainbow-delimiters
			-- extmark at that nesting level, so bracket and scope line match.
			hooks.register(
				hooks.type.SCOPE_HIGHLIGHT,
				hooks.builtin.scope_highlight_from_extmark
			)
		end,
	},
	{
		"numToStr/Comment.nvim",
		opts = {
			---Add a space b/w comment and the line
			padding = true,
			---Whether the cursor should stay at its position
			sticky = true,
			-- add any options here
		},
		lazy = false,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = true, -- show icons in the signs column
			sign_priority = 8, -- sign priority
			-- keywords recognized as todo comments
			keywords = {
				FIX = {
					icon = " ", -- icon used for the sign, and in search results
					color = "error", -- can be a hex color, or a named color (see below)
					alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
					-- signs = false, -- configure signs for some keywords individually
				},
				TODO = { icon = " ", color = "info" },
				HACK = { icon = " ", color = "warning" },
				WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
				PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
				NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
				TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
			},
			colors = {
				error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
				warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
				info = { "DiagnosticInfo", "#2563EB" },
				hint = { "DiagnosticHint", "#10B981" },
				default = { "Identifier", "#7C3AED" },
				test = { "Identifier", "#FF00FF" },
			},
		},
	},
	{
		"tpope/vim-sleuth",
	},
	{
		"b0o/schemastore.nvim",
	}
}
