return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.5",
	dependencies = { { "nvim-lua/plenary.nvim" } },

	-- init = function() end,

	config = function()
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<A-f>", builtin.find_files, {})
		vim.keymap.set("n", "<A-g>", builtin.git_files, {})
		vim.keymap.set("n", "<A-s>", function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end)
		vim.keymap.set("t", "<A-f>", function()
			vim.cmd("close")
			builtin.find_files()
		end)
		vim.keymap.set("t", "<A-g>", function()
			vim.cmd("close")
			builtin.git_files()
		end)
		vim.keymap.set("t", "<A-s>", function()
			vim.cmd("close")
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end)
	end,
}
