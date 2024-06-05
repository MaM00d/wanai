-- Main
vim.g.mapleader = " "
vim.keymap.set("n", "Q", function()
	vim.cmd("q!")
end)
vim.keymap.set("n", "W", function()
	vim.cmd("w!")
end)
--move blocks of code in vesion mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

--fix the cursor inthe middle while searching
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "n", "nzzzv")

--fix the cursor in the middle while half page move
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
--use all word
-- vim.keymap.set("n", "cw", "ciw")
-- vim.keymap.set("n", "dw", "diw")
-- vim.keymap.set("n", "dw", "diw")
-- vim.keymap.set("n", "yw", "yiw")
-- vim.keymap.set("v", "w", "iw")

--copy past delete
vim.keymap.set("v", "p", [["_dP]]) --past over text without taking it to copy buffer
vim.keymap.set({ "n", "v" }, "<A-y>", [["+y]]) --copy in system
vim.keymap.set("n", "<A-Y>", [["+Y]]) --copy in system
vim.keymap.set({ "n", "v" }, "<A-p>", [["+p]]) --past in system
vim.keymap.set({ "n", "v" }, "<A-P>", [["+P]]) --past in system
vim.keymap.set({ "n", "v" }, "<A-d>", [["_d]]) --avoid buffer while delete
