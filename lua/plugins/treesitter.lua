return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master", -- master keeps the classic configs API; main is a full rewrite
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				auto_install = false,
				ensure_installed = { "lua", "c", "rust", "cpp", "typescript", "tsx", "sql" },
				highlight = {
					enable = true,
					disable = function(_, buf)
						local max = 200 * 1024 -- 200KB
						local ok, st = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
						return ok and st and st.size > max
					end,
				},
				indent = { enable = true },
			})
		end,
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
