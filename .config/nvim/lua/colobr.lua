return {

	"hiphish/rainbow-delimiters.nvim",
	config = function()
		-- This module contains a number of default definitions
		local rainbow_delimiters = require("rainbow-delimiters")

		vim.cmd("highlight babyblue guifg=#89cff0")
		vim.cmd("highlight babypurple guifg=#CA9BF7")
		vim.cmd("highlight babyred guifg=#FF7779")
		vim.cmd("highlight babyyellow guifg=#FFFCC9")
		vim.cmd("highlight babygreen guifg=#8CFF9E")

		vim.g.rainbow_delimiters = {
			strategy = {
				[""] = rainbow_delimiters.strategy["local"],
				-- vim = rainbow_delimiters.strategy["local"],
			},
			query = {
				[""] = "rainbow-delimiters",
				lua = "rainbow-blocks",
			},
			priority = {
				[""] = 110,
				lua = 210,
			},
			highlight = {
				"babyyellow",
				"babygreen",
				"babyblue",
				"babypurple",
				"babyred",
			},
		}
	end,
}
