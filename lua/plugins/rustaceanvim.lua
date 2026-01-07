return {
	"mrcjkb/rustaceanvim",
	version = "^5", -- Recommended
	lazy = false, -- This plugin is already lazy
	config = function()
		local original_caps = vim.lsp.protocol.make_client_capabilities()
		local capabilities = require("blink.cmp").get_lsp_capabilities(original_caps)

		vim.g.rustaceanvim = {
			-- Plugin configuration
			tools = {
				create_graph = {
					full = false,
				},
			},
			-- LSP configuration
			server = {
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					-- you can also put keymaps in here
				end,
				default_settings = {
					-- rust-analyzer language server configuration
					["rust-analyzer"] = {
						cargo = {
							loadOutDirsFromCheck = true,
							-- target = "x86_64-pc-windows-gnu",
							runBuildScripts = false, -- Disable build scripts, including `crateGraph` task
							allTargets = true
						},
						check = {
							allTargets = true,
						},
						procMacro = { enable = true },
						hoverActions = { references = false },
						inlayHints = {
							enable = true, -- Enable inlay hints
							typeHints = true, -- Show type hints
							parameterHints = true, -- Show parameter hints
						},
						diagnostics = {},
					},
				},
			},
			-- DAP configuration
			dap = {},
		}

		-- Target switching with LSP restart for proper configuration
		-- Switch to Windows target (x86_64-pc-windows-gnu)
		vim.keymap.set("n", "<leader>tw", function()
			vim.cmd("RustAnalyzer target x86_64-pc-windows-gnu")
			vim.cmd("RustAnalyzer restart")
		end, { desc = "Switch to Windows target" })

		-- Switch to macOS target (aarch64-apple-darwin)
		vim.keymap.set("n", "<leader>tm", function()
			vim.cmd("RustAnalyzer target aarch64-apple-darwin")
			vim.cmd("RustAnalyzer restart")
		end, { desc = "Switch to macOS target" })

		for _, method in ipairs({ "textDocument/diagnostic", "workspace/diagnostic" }) do
			local default_diagnostic_handler = vim.lsp.handlers[method]
			vim.lsp.handlers[method] = function(err, result, context, config)
				if err ~= nil and err.code == -32802 then
					return
				end
				return default_diagnostic_handler(err, result, context, config)
			end
		end
	end,
}
