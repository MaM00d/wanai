return {

	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },

	init = function()
		local harpoon = require("harpoon")

		-- REQUIRED
		harpoon:setup({

			settings = {
				save_on_toggle = true,
				sync_on_ui_close = true,
			},
		})
		-- REQUIRED

		vim.keymap.set("n", "<M-a>", function()
			harpoon:list():append()
		end)
		vim.keymap.set("n", "<M-e>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end)

		vim.keymap.set("n", "<M-j>", function()
			harpoon:list():select(1)
		end)
		vim.keymap.set("n", "<M-k>", function()
			harpoon:list():select(2)
		end)
		vim.keymap.set("n", "<M-l>", function()
			harpoon:list():select(3)
		end)
		vim.keymap.set("n", "<M-;>", function()
			harpoon:list():select(4)
		end)

		vim.keymap.set("t", "<M-j>", function()
			vim.cmd("close")
			harpoon:list():select(1)
		end)
		vim.keymap.set("t", "<M-k>", function()
			vim.cmd("close")
			harpoon:list():select(2)
		end)
		vim.keymap.set("t", "<M-l>", function()
			vim.cmd("close")
			harpoon:list():select(3)
		end)
		vim.keymap.set("t", "<M-;>", function()
			vim.cmd("close")
			harpoon:list():select(4)
		end)
		vim.keymap.set("t", "<M-e>", function()
			vim.cmd("close")
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end)
		-- Toggle previous & next buffers stored within Harpoon list
		-- vim.keymap.set("n", "<M-S-P>", function()
		-- 	harpoon:list():prev()
		-- end)
		-- vim.keymap.set("n", "<C-S-N>", function()
		-- 	harpoon:list():next()
		-- end)
	end,
}
