return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			vim.opt.termguicolors = true

			require("bufferline").setup({
				options = {
					separator_style          = "slant",
					show_buffer_close_icons  = false,
					show_close_icon          = false,
					enforce_regular_tabs     = true,
					always_show_bufferline   = true,
					diagnostics              = "nvim_lsp",
					indicator = {
						style = "icon",
						icon  = "▎",
					},
					-- Active buffer: relative path so you can tell apart same-named files.
					-- Inactive buffers: filename only to keep the bar compact.
					name_formatter = function(buf)
						if buf.id == vim.fn.bufnr("%") then
							return vim.fn.fnamemodify(buf.path, ":~:.")
						else
							return vim.fn.fnamemodify(buf.path, ":t")
						end
					end,
				},
				-- No highlight overrides — bufferline inherits from the active colorscheme.
			})
		end,
	},
}
