vim.cmd("set termguicolors")
vim.cmd("set number relativenumber")
vim.cmd("set nu rnu")
vim.cmd("set splitbelow")
vim.cmd("set termbidi")
vim.cmd("set foldmethod=expr")
vim.cmd("set foldexpr=nvim_treesitter#foldexpr()")
vim.cmd("autocmd BufReadPost,FileReadPost * normal zR")
vim.cmd("set nofoldenable")
vim.g.NERDTreeHijackNetrw = 0
vim.g.lf_replace_netrw = 1
