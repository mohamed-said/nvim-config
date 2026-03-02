-- return {
-- 	{
-- 		"nvim-telescope/telescope.nvim",
-- 		dependencies = { "nvim-lua/plenary.nvim" },
-- 		config = function()
-- 			local builtin = require("telescope.builtin")
-- 			vim.keymap.set("n", "<C-p>", builtin.find_files, {})
-- 			vim.keymap.set("n", "<C-g>", builtin.live_grep, {})
-- 			vim.keymap.set("n", "<C-b>", builtin.buffers, {})
-- 		end,
-- 	},
-- 	{
-- 		"nvim-telescope/telescope-fzf-native.nvim",
-- 		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
-- 	},
-- 	{
-- 		"nvim-telescope/telescope-ui-select.nvim",
-- 		config = function()
-- 			-- This is your opts table
-- 			require("telescope").setup({
-- 				defaults = {
-- 					preview = { treesitter = false },
-- 					file_ignore_patterns = {
-- 						"node_modules/",
-- 						"dist/",
-- 						"build/",
-- 						".next/",
-- 						".turbo/",
-- 						".git/",
-- 					},
-- 				},
-- 				pickers = {
-- 					live_grep = {
-- 						on_input_filter_cb = function(query)
-- 							-- Replace spaces with `.*` for regex matching
-- 							return query:gsub(" ", ".*")
-- 						end,
-- 					},
-- 				},
-- 				extensions = {
-- 					["ui-select"] = {
-- 						require("telescope.themes").get_dropdown({
-- 							-- even more opts
-- 						}),
-- 						-- pseudo code / specification for writing custom displays, like the one
-- 						-- for "codeactions"
-- 						-- specific_opts = {
-- 						--   [kind] = {
-- 						--     make_indexed = function(items) -> indexed_items, width,
-- 						--     make_displayer = function(widths) -> displayer
-- 						--     make_display = function(displayer) -> function(e)
-- 						--     make_ordinal = function(e) -> string
-- 						--   },
-- 						--   -- for example to disable the custom builtin "codeactions" display
-- 						--      do the following
-- 						--   codeactions = false,
-- 						-- }
-- 					},
-- 				},
-- 			})
-- 			-- To get ui-select loaded and working with telescope, you need to call
-- 			-- load_extension, somewhere after setup function:
-- 			require("telescope").load_extension("ui-select")
-- 		end,
-- 	},
-- }
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
      },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
      local themes = require("telescope.themes")

      telescope.setup({
        defaults = {
          -- Keep preview enabled, but avoid heavy preview work on huge files
          preview = {
            treesitter = false,
            filesize_limit = 0.2, -- MB (tune: 0.2–0.5 is usually a good range)
          },

          -- Keep the repo junk out of candidate lists
          file_ignore_patterns = {
            "node_modules/",
            "dist/",
            "build/",
            "%.next/",
            "%.turbo/",
            "%.git/",
            "coverage/",
            ".cache/",
          },
        },

        -- No custom live_grep filter (the space->.* regex expansion can slow things down)
		pickers = {
			find_files = {
				hidden = true,
				find_command = {
					"fd", "--type", "f",
					"--hidden",
					-- "--follow", -- do NOT follow symlinks
					"--exclude", ".git",
					"--exclude", "node_modules",
					"--exclude", ".turbo",
					"--exclude", ".next",
					"--exclude", "dist",
					"--exclude", "build",
				},
			},
		},

        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          ["ui-select"] = themes.get_dropdown({}),
        },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")

      vim.keymap.set("n", "<C-p>", builtin.find_files, {})
      vim.keymap.set("n", "<C-g>", builtin.live_grep, {})
      vim.keymap.set("n", "<C-b>", builtin.buffers, {})
    end,
  },
}

