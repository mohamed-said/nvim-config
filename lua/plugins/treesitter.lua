return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			auto_install = true,
			ensure_installed = { "lua", "c", "rust", "cpp" },
			highlight = { enable = true },
			indent = { enable = true },
		},
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		config = function()
			require("rainbow-delimiters.setup").setup({
				strategy = {
					-- ...
				},
				query = {
					-- ...
				},
				highlight = {
					-- ...
				},
			})
		end,
	},
}
