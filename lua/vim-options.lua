-- Disable Neovim 0.11's built-in LSP auto-start for rust-analyzer
-- (rustaceanvim handles this)
vim.lsp.enable('rust_analyzer', false)

vim.cmd("set encoding=UTF-8")
vim.cmd("set cursorline")

vim.cmd("set number")


vim.cmd("set ruler")
vim.cmd("set wildmenu")

vim.cmd("set textwidth=79")
vim.cmd("set tabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set softtabstop=4")
vim.cmd("set expandtab")

vim.cmd("set incsearch")
vim.cmd("set hlsearch")

-- vim.cmd("set regexpengine=1") -- REMOVED: old regex engine is slow with TypeScript
vim.cmd("set backspace=indent,eol,start")

vim.cmd("set fillchars+=vert:│")

-- Global default border for all floating windows (Neovim 0.11+).
-- Covers hover (K), signature help, diagnostics float, and any other float
-- that doesn't set its own border explicitly.
vim.o.winborder = "rounded"

-- Run only once after coc install
-- call coc#util#install()
--
-- Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force user to select one from the menu
vim.cmd("set completeopt=menuone,noinsert,noselect")

-- Avoid showing extra messages when using completion
vim.cmd("set shortmess+=c")

vim.opt.termguicolors = true

vim.wo.relativenumber = true

vim.g.airline_theme = "badwolf"
vim.g["airline#extensions#tabline#enabled"] = 1
vim.g.airline_powerline_fonts = 1

-- vim.o.foldmethod = 'expr'
-- vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
-- vim.o.foldlevelstart = 99

-- Window Navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })
vim.keymap.set("n", "<A-h>", ":noh<CR>", { noremap = true, silent = true })

vim.keymap.set("n", 'c"', 'ci"', { noremap = true, silent = true })
vim.keymap.set("n", "c'", "ci'", { noremap = true, silent = true })
vim.keymap.set("n", "c(", "ci(", { noremap = true, silent = true })
vim.keymap.set("n", "c[", "ci[", { noremap = true, silent = true })
vim.keymap.set("n", "c{", "ci{", { noremap = true, silent = true })
vim.keymap.set("n", "c<", "ci<", { noremap = true, silent = true })

-- Inlay Hints
vim.keymap.set("n", "<leader>i", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ 0 }), { 0 })
end)

-- Diagnostics
vim.keymap.set("n", "<space>e", function()
	vim.diagnostic.open_float({ scope = "line" })
end, { silent = true, desc = "Open line diagnostics float" })

vim.keymap.set("n", "<space>ne", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { silent = true, desc = "Next diagnostic" })

vim.keymap.set("n", "<space>pe", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { silent = true, desc = "Previous diagnostic" })

-- HexDump
vim.keymap.set("n", "<leader>hd", ":%!xxd<CR>", { noremap = true, silent = true })

vim.api.nvim_create_user_command("LualineTheme", function(opts)
	local lualine = require("lualine")
	local config = lualine.get_config() -- Retrieve the current configuration
	config.options.theme = opts.args -- Update the theme
	lualine.setup(config) -- Apply the updated configuration
end, { nargs = 1 })

-- Map the function to a keybinding
vim.api.nvim_set_keymap(
	"n",
	"<leader>fu",
	"<cmd>lua show_function_usages()<CR>",
	{ noremap = true, silent = true, desc = "Find usages of the function under the cursor" }
)

-- Colorscheme Switch
vim.api.nvim_create_user_command("Lightmode", function()
  vim.cmd("colorscheme lightning") -- Example command
  vim.cmd("LualineTheme ayu_light") -- Another example command
end, {})


vim.api.nvim_create_user_command("Darkmode", function()
  vim.cmd("colorscheme Oshen") -- Example command
  vim.cmd("LualineTheme horizon") -- Another example command
end, {})

vim.api.nvim_set_keymap("n", "<leader>L", ":Lightmode<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>D", ":Darkmode<CR>", { noremap = true, silent = true })

-- Save hotkey
vim.api.nvim_set_keymap("n", "<leader>w", ":w<CR>", { noremap = true, silent = true })


vim.api.nvim_set_keymap("n", "<leader>o", ":noh<CR>", {noremap = true, silent = true})


vim.keymap.set("v", "<leader>y", '"*y', { noremap = true, silent = true, desc = "Yank selection to system clipboard" })
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Function to delete trailing whitespace
local function delete_trailing_ws()
	-- Save cursor position
	vim.cmd("normal! mz")
	-- Remove trailing whitespace globally
	vim.cmd([[%s/\s\+$//e]])
	-- Restore cursor position
	vim.cmd("normal! `z")
end

-- Set an autocmd to call the function on BufWrite
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = delete_trailing_ws,
})

function CopyFilePathAndLine()
	local file_path = vim.fn.expand("%:p")
	local line_number = vim.fn.line(".")
	local result = file_path .. ":" .. line_number
	vim.fn.setreg("+", result)
	print("Copied: " .. result)
end

-- vim.api.nvim_create_user_command('CopyPathAndLine', CopyFilePathAndLine, {})
vim.api.nvim_set_keymap("n", "<space>c", ":lua CopyFilePathAndLine()<CR>", { noremap = true, silent = true })
