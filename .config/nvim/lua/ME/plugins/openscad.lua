return {
	"salkin-mada/openscad.nvim",
	ft = "openscad",
	dependencies = { "L3MON4D3/LuaSnip", "vijaymarupudi/nvim-fzf" },
	config = function()
		require("openscad")
		-- load snippets, note requires
		vim.g.openscad_fuzzy_finder = "fzf"
		vim.g.openscad_load_snippets = true
		vim.g.openscad_default_mappings = true
		vim.g.openscad_auto_open = false
		vim.g.openscad_cheatsheet_toggle_key = "<Enter>"
		vim.g.openscad_help_trig_key = "<A-h>"
		vim.g.openscad_help_manual_trig_key = "<A-m>"
		vim.g.openscad_exec_openscad_trig_key = "<A-o>"
		vim.g.openscad_top_toggle = "<A-c>"
	end,
}
