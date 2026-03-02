return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			auto_install = false,
			ensure_installed = { "lua", "c", "rust", "cpp", "typescript", "tsx" },
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
