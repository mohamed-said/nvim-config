return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettier.with({
					-- Configure Prettier to avoid adding trailing commas
					extra_args = { "--trailing-comma", "none" },
				}),
				null_ls.builtins.formatting.black,
				null_ls.builtins.diagnostics.eslint_d,
			},
		})
	end,
}
