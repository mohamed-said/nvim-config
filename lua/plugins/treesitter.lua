return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			auto_install = false,
			ensure_installed = { "lua", "c", "rust", "cpp", "typescript", "tsx", "sql" },
			highlight = {
				enable = true,
				disable = function(_, buf)
					local max = 200 * 1024 -- 200KB
					local ok, st = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					return ok and st and st.size > max
				end,
			},
			indent = { enable = true },
		},
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		config = function()
			-- Use the same named highlight groups as indent-blankline so the
			-- bracket colors and scope/indent lines stay in sync.
			require("rainbow-delimiters.setup").setup({
				highlight = {
					"RainbowRed",
					"RainbowYellow",
					"RainbowBlue",
					"RainbowOrange",
					"RainbowGreen",
					"RainbowViolet",
					"RainbowCyan",
				},
			})
		end,
	},
}
