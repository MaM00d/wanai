return {

	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		"lvimuser/lsp-inlayhints.nvim",
	},
	priority = 900,
	config = function()
		local lspconfig = require("lspconfig")

		--  ╭──────────────────────────────────────────────────────────╮
		--  │                         SERVERS                          │
		--  ╰──────────────────────────────────────────────────────────╯

		-- Lua server
		lspconfig.lua_ls.setup({})
		lspconfig.gopls.setup({})
		lspconfig.pyright.setup({})
		lspconfig.ast_grep.setup({})
		lspconfig.clangd.setup({})
		lspconfig.cssls.setup({})
		lspconfig.texlab.setup({})
		lspconfig.rust_analyzer.setup({
			settings = {
				["rust-analyzer"] = {
					cargo = {
						allFeatures = true,
						features = { "all" }, -- features = ssr, for LSP support in leptos SSR functions
						-- loadOutDirsFromCheck = true,
						runBuildScripts = true,
						extraEnv = {
							RUSTFLAGS = "--cfg rust_analyzer",
						},
					},
					-- Add clippy lints for Rust.
					checkOnSave = {
						allFeatures = true,
						command = "clippy",
						extraArgs = { "--no-deps" },
					},
					-- procMacro = {
					-- 	enable = true,
					-- 	ignored = {
					-- 		["async-trait"] = { "async_trait" },
					-- 		["napi-derive"] = { "napi" },
					-- 		["async-recursion"] = { "async_recursion" },
					-- 	},
					-- },
				},
			},
		})
		require("lspconfig").openscad_lsp.setup({})

		-- Keymaps
		vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
		vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Enable completion triggered by <c-x><c-o>
				vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf }
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
				vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
				vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
				vim.keymap.set("n", "<space>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, opts)
				vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
				vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "<space>lf", function()
					vim.lsp.buf.format({ async = true })
				end, opts)
			end,
		})

		-----------------

		-- Diagnostics signs  
		-- local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		-- for type, icon in pairs(signs) do
		-- 	local hl = "DiagnosticSign" .. type
		-- 	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		-- end
		--
		-- vim.diagnostic.config({
		-- 	virtual_text = {
		-- 		prefix = "", -- Could be '●', '▎', │, 'x', '■', , 
		-- 	},
		--
		-- 	-- float = { border = border },
		-- 	-- virtual_text = false,
		-- 	-- signs = true,
		-- 	-- underline = true,
		-- })

		------------------

		-- LSP settings (for overriding per client)
		-- local handlers = {
		-- 	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
		-- 	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
		-- }

		-- Disable lsp (not cmp) inline diagnostics error messages
		-- vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		--     virtual_text = false,
		-- })
	end,
}
