return {
	-- Main LSP Configuration
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for Neovim
		-- Mason must be loaded before its dependents so we need to set it up here.
		-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
		{ "williamboman/mason.nvim", opts = {} },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"linrongbin16/lsp-progress.nvim",
		"b0o/schemastore.nvim",

		-- Useful status updates for LSP.
		{ "j-hui/fidget.nvim", opts = {} },
	},
	config = function()
		-- Diagnostic Config
		-- See :help vim.diagnostic.Opts
		vim.diagnostic.config({
			severity_sort = true,
			float = { border = "rounded", source = "if_many" },
			underline = { severity = vim.diagnostic.severity.ERROR },
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "󰀪 ",
					[vim.diagnostic.severity.INFO] = "󰋽 ",
					[vim.diagnostic.severity.HINT] = "󰌶 ",
					-- -- -- -- -- -- -- -- -- -- -- -- --
					-- [vim.diagnostic.severity.ERROR] = "󰅚 ",
					-- [vim.diagnostic.severity.ERROR] = " ",
					-- [vim.diagnostic.severity.WARN] = " ",
					-- [vim.diagnostic.severity.INFO] = "󰠠 ",
					-- [vim.diagnostic.severity.HINT] = " ",
				},
			},
			virtual_text = {
				source = "if_many",
				spacing = 2,
				format = function(diagnostic)
					local diagnostic_message = {
						[vim.diagnostic.severity.ERROR] = diagnostic.message,
						[vim.diagnostic.severity.WARN] = diagnostic.message,
						[vim.diagnostic.severity.INFO] = diagnostic.message,
						[vim.diagnostic.severity.HINT] = diagnostic.message,
					}
					return diagnostic_message[diagnostic.severity]
				end,
			},
		})

		local original_caps = vim.lsp.protocol.make_client_capabilities()
		local capabilities = require("blink.cmp").get_lsp_capabilities(original_caps)
		local lsp_util = require("lspconfig.util")

		local servers = {
			bashls = {},
			marksman = {},
			ts_ls = {
				capabilities = capabilities,
				root_dir = lsp_util.root_pattern("tsconfig.json", "jsconfig.json", "package.json"),
				single_file_support = false,
				on_attach = function(client, bufnr)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
					vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
				end,
			},
			jsonls = {
				capabilities = capabilities,
				settings = {
					json = {
						-- schemas = require('schemastore').json.schemas {
						--     ignore = {
						--         '.eslintrc',
						--         'package.json',
						--     },
						-- },
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			},
			nil_ls = {
				capabilities = capabilities,
				settings = {
					formatting = {
						command = {
							"nixfmt",
						},
					},
				},
			},
			taplo = {
				capabilities = capabilities,
			},
			clangd = {
				capabilities = capabilities,
				-- Optional: Customize clangd settings (e.g., using a specific config file)
				cmd = { "clangd", "--background-index" },
				filetypes = { "c", "cpp", "cc", "h", "hpp", "objc", "objcpp" }, -- Define the file types it should work with
			},
			eslint = {
				capabilities = capabilities,
				flags = {
					allow_incremental_sync = false,
					debounce_text_changes = 1000,
					exit_timeout = 1500,
				},
				on_attach = function(client, _)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end,
			},
			terraformls = {
				capabilities = capabilities,
				filetypes = { "terraform", "terraform-vars" },
				root_dir = lsp_util.root_pattern(".terraform", ".git"),
			},
			postgres_lsp = {
				capabilities = capabilities,
			},
		}
		local ensure_installed = vim.tbl_keys(servers or {})
		-- Remove rust-analyzer from auto-installation since rustaceanvim manages it
		ensure_installed = vim.tbl_filter(function(tool)
			return tool ~= "rust_analyzer"
		end, ensure_installed)
		vim.list_extend(ensure_installed, {
			"stylua",               -- Used to format Lua code
			"prettierd",            -- Used to format javascript and typescript code
			"postgres-language-server", -- SQL/PostgreSQL LSP
			"pgformatter",          -- SQL formatter
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
		require("mason-lspconfig").setup({
			ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
			automatic_installation = false,
			handlers = {
				function(server_name)
					if server_name == "rust_analyzer" then
						return
					end

					-- ✅ none-ls/null-ls is not an lspconfig server
					if server_name == "null-ls" or server_name == "none-ls" then
						return
					end

					local lspconfig = require("lspconfig")
					if not lspconfig[server_name] then
						return
					end

					local server = servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					lspconfig[server_name].setup(server)
				end,
			},
		})

		vim.lsp.inlay_hint.enable(true)

		-- Borders for hover / signature help / diagnostic floats are handled
		-- globally by `vim.o.winborder = "rounded"` in vim-options.lua.

		vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
		vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
		vim.keymap.set({ "n", "v" }, "<leader>f", function()
			vim.lsp.buf.format({ async = true })
			-- require("conform").format({ async = true })
		end, {})
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
	end,
}
