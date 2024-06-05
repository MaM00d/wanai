return {
	-- "chrisbra/vim-commentary",
	-- { "neoclide/coc.nvim", branch = "release" },
	--sudo ask plugin
	"lambdalisue/suda.vim",
	--requried for telescope treesetter obsidian and more
	"nvim-lua/plenary.nvim",
	--lighten word under cursor
	"RRethy/vim-illuminate",
	{
		"aserowy/tmux.nvim",
		config = function()
			return require("tmux").setup()
		end,
	},
	{
		"tpope/vim-surround",
	},

	{
		"mhinz/vim-startify",
		priority = 800,
	},
	-- {
	-- 	"jiaoshijie/undotree",
	-- 	dependencies = "nvim-lua/plenary.nvim",
	-- 	config = true,
	-- 	keys = { -- load the plugin only when using it's keybinding:
	-- 		{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
	-- 	},
	-- },
	{

		"tpope/vim-fugitive",
		keys = {

			{ "<leader>gs", vim.cmd.Git },
		},
	},
	{
		"m4xshen/autoclose.nvim",
		config = function()
			require("autoclose").setup()
		end,
	},
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},
	{
		"lervag/vimtex",
		lazy = false,
		init = function()
			syntax = enable
			vim.g.vimtex_syntax_match_unicode = 1
			vim.g.vimtex_indent_enabled = 1
			-- vim.g.vimtex_compiler_method = "arara"

			vim.g.vimtex_compiler_latexmk = {
				executable = "latexmk",
				options = {
					"-xelatex",
					"-file-line-error",
					"-synctex=1",
					"-interaction=nonstopmode",
				},
			}
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
				max_lines = 2, -- How many lines the window should span. Values <= 0 mean no limit.
				min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
				line_numbers = true,
				multiline_threshold = 20, -- Maximum number of lines to show for a single context
				trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
				mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
				-- Separator between context and content. Should be a single character string, like '-'.
				-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
				separator = nil,
				zindex = 20, -- The Z-index of the context window
				on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
			})
		end,
	},
	--session restore
	-- "rmagatti/auto-session",
}
