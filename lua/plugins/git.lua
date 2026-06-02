return {
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<leader>gtb", ":G blame<CR>")
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add          = { text = "│" },
				change       = { text = "│" },
				delete       = { text = "_" },
				topdelete    = { text = "‾" },
				changedelete = { text = "~" },
				untracked    = { text = "┆" },
			},
			signs_staged = {
				add          = { text = "│" },
				change       = { text = "│" },
				delete       = { text = "_" },
				topdelete    = { text = "‾" },
				changedelete = { text = "~" },
			},
			signs_staged_enable = true,
			word_diff   = false,
			on_attach   = function(bufnr)
				local gs = require("gitsigns")

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
				end

				-- Navigation: jump between hunks (falls back to built-in ]c/[c in diff mode)
				map("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gs.nav_hunk("next")
					end
				end, "Next hunk")

				map("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gs.nav_hunk("prev")
					end
				end, "Prev hunk")

				-- Hunk actions
				map("n", "<leader>hs", gs.stage_hunk,                        "Stage hunk")
				map("n", "<leader>hr", gs.reset_hunk,                        "Reset hunk")
				map("n", "<leader>hS", gs.stage_buffer,                      "Stage buffer")
				map("n", "<leader>hR", gs.reset_buffer,                      "Reset buffer")
				map("n", "<leader>hu", gs.undo_stage_hunk,                   "Undo stage hunk")
				map("n", "<leader>hp", gs.preview_hunk_inline,               "Preview hunk inline")
				map("n", "<leader>hd", gs.diffthis,                          "Diff against index")
				map("n", "<leader>hD", function() gs.diffthis("~") end,      "Diff against last commit")

				-- Also works on visual selections (stage/reset only the selected lines)
				map("v", "<leader>hs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Stage selected lines")
				map("v", "<leader>hr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Reset selected lines")

				-- Blame
				map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line (full)")

				-- Toggles
				map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle inline blame")
				map("n", "<leader>tw", gs.toggle_word_diff,          "Toggle word diff")

				-- Text object: select a hunk with `ih` in operator/visual mode
				map({ "o", "x" }, "ih", gs.select_hunk, "Select hunk")
			end,
		},
	},
}
