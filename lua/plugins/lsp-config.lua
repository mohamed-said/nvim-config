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

		-- Useful status updates for LSP.
		{ "j-hui/fidget.nvim",       opts = {} },
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

		local servers = {
			bashls = {},
			marksman = {},
			-- clangd = {},
			-- gopls = {},
			-- pyright = {},
			-- rust_analyzer = {},
			-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
			--
			-- Some languages (like typescript) have entire language plugins that can be useful:
			--    https://github.com/pmizio/typescript-tools.nvim
			--
			-- But for many setups, the LSP (`ts_ls`) will work just fine
			ts_ls = {
				capabilities = capabilities,
			},
			--

			lua_ls = {
				capabilities = capabilities,
				-- cmd = { ... },
				-- filetypes = { ... },
				-- capabilities = {},
				-- settings = {
				--   Lua = {
				--     completion = {
				--       callSnippet = 'Replace',
				--     },
				--     -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
				--     -- diagnostics = { disable = { 'missing-fields' } },
				--   },
				-- },
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
				-- Optional: Customize clangd settings (e.g., using a specific config file)
				cmd = { "clangd", "--background-index" },
				filetypes = { "c", "cpp", "cc", "h", "hpp", "objc", "objcpp" }, -- Define the file types it should work with
			},
		}
		local ensure_installed = vim.tbl_keys(servers or {})
		-- Remove rust-analyzer from auto-installation since rustaceanvim manages it
		ensure_installed = vim.tbl_filter(function(tool)
			return tool ~= "rust_analyzer"
		end, ensure_installed)
		vim.list_extend(ensure_installed, {
			"stylua", -- Used to format Lua code
			"prettierd", -- Used to format javascript and typescript code
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
		require("mason-lspconfig").setup({
			ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
			automatic_installation = false,
			handlers = {
				function(server_name)
					-- Skip rust_analyzer since rustaceanvim manages it
					if server_name == "rust_analyzer" then
						return
					end
					local server = servers[server_name] or {}
					-- This handles overriding only values explicitly passed
					-- by the server configuration above. Useful when disabling
					-- certain features of an LSP (for example, turning off formatting for ts_ls)
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})

		vim.lsp.inlay_hint.enable(true)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
		vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
		vim.keymap.set({ "n", "v" }, "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, {})
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
	end,
}
