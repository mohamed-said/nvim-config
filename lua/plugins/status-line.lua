return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = require("oshen.integrations.lualine").get(),
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					globalstatus = false,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "diff", "diagnostics" },
					lualine_c = {
						{
							"filename",
							file_status = true, -- displays file status (readonly status, modified status)
							path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
						},
					},
					lualine_x = {
						"encoding",
						{
							"fileformat",
							symbols = {
								mac = "", -- e711
								unix = "", -- e712
								dos = "", -- e70f
							},
						},
						"filetype",
					},
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {},
			})
		end,
	},
	{
		"j-hui/fidget.nvim",
		opts = {
			notification = {
				window = {
					-- winblend = 0 lets normal_hl control the background directly.
					-- Since Oshen's transparent mode sets Normal to bg = NONE,
					-- the window inherits that and shows the terminal wallpaper.
					winblend  = 0,
					normal_hl = "Normal",
					border    = "none",
				},
			},
		},
	},
}
