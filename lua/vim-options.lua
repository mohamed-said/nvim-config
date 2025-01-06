vim.cmd("set encoding=UTF-8")
vim.cmd("set cursorline")

vim.cmd("set number")

vim.wo.relativenumber = true

vim.cmd("set ruler")
vim.cmd("set wildmenu")

vim.cmd("set textwidth=79")
vim.cmd("set tabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set softtabstop=4")
vim.cmd("set expandtab")

vim.cmd("set incsearch")
vim.cmd("set hlsearch")

vim.cmd("set regexpengine=1")
vim.cmd("set backspace=indent,eol,start")

vim.cmd("set fillchars+=vert:│")

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

vim.o.termguicolors = true

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
vim.api.nvim_set_keymap(
	"n",
	"<space>e",
	'<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<CR>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap("n", "<space>ne", "<cmd>lua vim.diagnostic.goto_next()<CR>", {})
vim.api.nvim_set_keymap("n", "<space>pe", "<cmd>lua vim.diagnostic.goto_prev()<CR>", {})

-- HexDump
vim.keymap.set("n", "<leader>hd", ":%!xxd<CR>", { noremap = true, silent = true })

vim.api.nvim_create_user_command("LualineTheme", function(opts)
	local lualine = require("lualine")
	local config = lualine.get_config() -- Retrieve the current configuration
	config.options.theme = opts.args -- Update the theme
	lualine.setup(config) -- Apply the updated configuration
end, { nargs = 1 })

local function show_function_usages()
	local params = vim.lsp.util.make_position_params()
	vim.lsp.buf_request(0, "textDocument/references", params, function(err, result, ctx, config)
		if err then
			vim.notify("Error finding references: " .. err.message, vim.log.levels.ERROR)
			return
		end
		if not result or vim.tbl_isempty(result) then
			vim.notify("No usages found", vim.log.levels.INFO)
			return
		end
		-- Show results in the quickfix list
		vim.lsp.util.set_qflist(vim.lsp.util.locations_to_items(result))
		vim.cmd("copen")
	end)
end

-- Map the function to a keybinding
vim.api.nvim_set_keymap(
	"n",
	"<leader>fu",
	"<cmd>lua show_function_usages()<CR>",
	{ noremap = true, silent = true, desc = "Find usages of the function under the cursor" }
)

vim.opt.termguicolors = true

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
