return {
	--treesetter
	"nvim-treesitter/nvim-treesitter",
	config = function()
		require("nvim-treesitter.configs").setup({

			-- A list of parser names, or "all" (the four listed parsers should always be installed)
			ensure_installed = { "latex", "html", "css", "javascript", "typescript", "c", "lua", "vim", "java" },
			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = true,

			-- Automatically install missing parsers when entering buffer
			-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
			auto_install = true,

			-- List of parsers to ignore installing (for "all")
			highlight = {
				enable = true,

				-- disable = { "latex" },
				-- additional_vim_regex_highlighting = { "latex", "markdown" },
				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				-- additional_vim_regex_highlighting = false,
			},
		})
	end,
}
