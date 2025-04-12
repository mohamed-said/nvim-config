-- return {
-- 	{
-- 		"akinsho/bufferline.nvim",
-- 		version = "*",
-- 		dependencies = "nvim-tree/nvim-web-devicons",
-- 		config = function()
-- 			vim.opt.termguicolors = true
-- 			require("bufferline").setup({
--
-- 			})
-- 		end,
-- 	},
-- }

return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      vim.opt.termguicolors = true

      require("bufferline").setup({
        options = {
          -- Simple separator style for modern look
          separator_style = "slant", -- Options: "slant", "thick", "thin", "padded_slant"
          show_buffer_close_icons = false,
          show_close_icon = false,
          enforce_regular_tabs = true,
          always_show_bufferline = true,
          diagnostics = "nvim_lsp", -- Optional: Show diagnostics in bufferline
          indicator = {
            style = "icon",
            icon = "▎", -- Stylish indicator for active buffer
          },
          -- Dynamically change buffer name based on active state
          name_formatter = function(buf)
            if buf.id == vim.fn.bufnr('%') then
              -- Active buffer: show full path
              return vim.fn.fnamemodify(buf.path, ":p")
            else
              -- Inactive buffers: show only file name
              return vim.fn.fnamemodify(buf.path, ":t")
            end
          end,
        },
        highlights = {
          fill = {
            guibg = "#1e1e2e", -- Background for unused space
          },
          background = {
            guifg = "#808080", -- Inactive buffer text color
            guibg = "#1e1e2e", -- Background for inactive buffers
          },
          buffer_selected = {
            guifg = "#ffffff", -- Text color for active buffer
            guibg = "#44475a", -- Background for active buffer
            gui = "bold", -- Bold text for selected buffer
          },
          separator = {
            guifg = "#44475a", -- Separator color for inactive buffers
            guibg = "#1e1e2e", -- Match background for smooth effect
          },
          separator_selected = {
            guifg = "#6272a4", -- Highlighted separator for active buffer
            guibg = "#44475a", -- Match active buffer background
          },
          indicator_selected = {
            guifg = "#ff79c6", -- Indicator color for active buffer
            guibg = "#44475a",
          },
        },
      })
    end,
  },
}

