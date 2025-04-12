return {
	"tpope/vim-fugitive",
	config = function()
		vim.keymap.set("n", "<leader>gtb", ":G blame<CR>")
	end,
}
