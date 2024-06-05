return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	priority = 1000,
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})
		mason_lspconfig.setup({
			ensure_installed = {
				"lua_ls",
			},
			-- auto-install configured servers (with lspconfig)
			-- automatic_installation = true, -- not the same as ensure_installed
		})
		mason_tool_installer.setup({
			ensure_installed = {
				"black",
				-- "prettier", -- prettier formatter
				-- "stylua", -- lua formatter
				-- "isort", -- python formatter
				-- -- "black", -- python formatter
				-- "pylint", -- python linter
				-- "lua-language-server",
			},

			run_on_start = true,
		})
	end,
}
