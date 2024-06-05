return {
	"luk400/vim-jukit",
	-- Lazy = true,
	-- ft = "python",
	init = function()
		vim.g.python3_host_prog = "/usr/bin/python3"

		vim.g.jukit_shell_cmd = "source venv/bin/activate && ipython3"
		-- Specifies the command used to start a shell in the output split. Can also be an absolute path. Can also be any other shell command, e.g. `R`, `julia`, etc. (note that output saving is only possible for ipython)

		vim.g.jukit_terminal = "nvimterm"
		-- Terminal to use. Can be one of '', 'kitty', 'vimterm', 'nvimterm' or 'tmux'. If '' is given then will try to detect terminal (though this might fail, in which case it simply defaults to 'vimterm' or 'nvimterm' - depending on the output of `has("nvim")`)

		vim.g.jukit_auto_output_hist = 1
		-- If set to 1, will create an autocmd with event `CursorHold` to show saved ipython output of current cell in output-history split. Might slow down (n)vim significantly, you can use `set updatetime=<number of milliseconds>` to control the time to wait until CursorHold events are triggered, which might improve performance if set to a higher number (e.g. `set updatetime=1000`).

		vim.g.jukit_use_tcomment = 0
		-- Whether to use tcomment plugin (https://github.com/tomtom/tcomment_vim) to comment out cell markers. If not, then cell markers will simply be prepended with `g:jukit_comment_mark`

		vim.g.jukit_comment_mark = "#"
		-- See description of `g:jukit_use_tcomment` above

		vim.g.jukit_mappings = 1
		-- If set to 0, none of the default function mappings (as specified further down) will be applied

		vim.g.jukit_mappings_ext_enabled = { "py", "ipynb" }
		-- String or list of strings specifying extensions for which the mappings will be created. For example, `vim.g.jukit_mappings_ext_enabled=['py', 'ipynb']` will enable the mappings only in `.py` and `.ipynb` files. Use `vim.g.jukit_mappings_ext_enabled='*'` to enable them for all files.

		vim.g.jukit_notebook_viewer = "jupyter-notebook"
		-- Command to open .ipynb files, by default jupyter-notebook is used. To use e.g. vs code instead, you could set this to `vim.g.jukit_notebook_viewer = 'code'`

		vim.g.jukit_convert_overwrite_default = 1
		-- Default setting when converting from .ipynb to .py or vice versa and a file of the same name already exists. Can be of [-1, 0, 1], where -1 means no default (i.e. you'll be prompted to specify what to do), 0 means never overwrite, 1 means always overwrite

		vim.g.jukit_convert_open_default = -1
		-- Default setting for whether the notebook should be opened after converting from .py to .ipynb. Can be of [-1, 0, 1], where -1 means no default (i.e. you'll be prompted to specify what to do), 0 means never open, 1 means always open

		vim.g.jukit_file_encodings = "utf-8"
		-- Default encoding for reading and writing to files in the python helper functions

		vim.g.jukit_venv_in_output_hist = 0
		-- Whether to also use the provided terminal command for the output history split when starting the splits using the JukitOUtHist command. If 0, the provided terminal command is only used in the output split, not in the output history split.

		-- vim.g.jukit_output_new_os_window = 0
		-- If set to 1, opens output split in new os-window. Can be used to e.g. write code in one kitty-os-window on your primary monitor while sending code to the shell which is in a seperate kitty-os-window on another monitor.

		-- vim.g.jukit_outhist_new_os_window = 0
		-- Same as `g:jukit_output_new_os_window`, only for output-history-split

		vim.g.jukit_in_style = 2
		-- -- - Number between 0 and 4. Defines how the input-code should be represented in the IPython shell. One of 5 different styles can be chosen, where style 0 is the default IPython style for the IPython-`%paste` command

		vim.g.jukit_max_size = 20
		-- -- - Max Size of json containing saved output in MiB. When the output history json gets too large, certain jukit operations can get slow, thus a max size is specified. Once the max size is reached, you'll be asked to delete some of the saved outputs (using e.g. jukit#cells#delete_outputs - see function explanation further down) before further output can be saved.

		vim.g.jukit_show_prompt = 0
		-- -- - Whether to show (1) or hide (0) the previous ipython prompt after code is sent to the ipython shell
		-- --IF AN IPYTHON SHELL COMMAND IS USED:

		vim.g.jukit_save_output = 1
		-- -- - Whether to save ipython output or not. This is the default value if an ipython shell command is used.
		--ELSE:
		--
		-- vim.g.jukit_save_output = 0
		-- -- - Whether to save ipython output or not. This is the default value if ipython is not used.

		vim.g.jukit_clean_outhist_freq = 60 * 10
		-- -- - Frequency in seconds with which to delete saved ipython output (including cached überzug images) of cells which are not present anymore. (After executing a cell of a buffer for the first time in a session, a CursorHold autocmd is created for this buffer which checks whether the last time obsolete output got deleted was more than `g:jukit_clean_outhist_freq` seconds ago, and if so, deletes all saved output of cells which are not present in the buffer anymore from the output-history-json)

		vim.g.jukit_savefig_dpi = 150
		-- -- - Value for `dpi` argument for matplotlibs `savefig` function

		vim.g.jukit_mpl_block = 1
		-- -- - If set to 0, then `plt.show()` will by default be executed as if `plt.show(block=False)` was specified

		vim.g.jukit_custom_backend = -1
		-- - Custom matplotlib backend to use

		--IF KITTY IS USED:
		-- vim.g.jukit_mpl_style = jukit#util#plugin_path() . '/helpers/matplotlib-backend-kitty/backend.mplstyle'
		-- - File specifying matplotlib plot options. This is the default value if kitty terminal is used
		--ELSE:

		vim.g.jukit_mpl_style = ""
		-- - File specifying matplotlib plot options. This is the default value if kitty terminal is NOT used. If '' is specified, no custom mpl-style is applied.

		--IF KITTY OR TMUX IS USED:

		vim.g.jukit_inline_plotting = 1
		-- - Enable in-terminal-plotting. Only supported for kitty or tmux+iTerm2 -> BE SURE TO SPECIFY THE TERMINAL VIA `g:jukit_terminal`! (see variables in section 'Basic jukit options')
		--ELSE:

		vim.g.jukit_inline_plotting = 0
		-- - Disable in-terminal-plotting

		--You can define a custom split layout as a dictionary, the default is:
		vim.g.jukit_layout = {
			split = "horizontal",
			p1 = 0.4,
			val = {
				"file_content",
				{
					split = "vertical",
					p1 = 0.6,
					val = { "output", "output_history" },
				},
			},
		}

		--this results in the following split layout:
		-- ______________________________________
		--|                      |               |
		--|                      |               |
		--|                      |               |
		--|                      |               |
		--|                      |     output    |
		--|                      |               |
		--|                      |               |
		--|    file_content      |               |
		--|                      |_______________|
		--|                      |               |
		--|                      |               |
		--|                      | output_history|
		--|                      |               |
		--|                      |               |
		--|______________________|_______________|
		-- "
		--The positions of all 3 split windows must be defined in the dictionary, even if
		--you don't plan on using the output_history split.
		-- "
		--dictionary keys:
		--'split':  Split direction of the two splits specified in 'val'. Either 'horizontal' or 'vertical'
		--'p1':     Proportion of the first split specified in 'val'. Value must be a float with 0 < p1 < 1
		--'val':    A list of length 2 which specifies the two splits for which to apply the above two options.
		--        One of the two items in the list must be a string and one must be a dictionary in case of
		--        the 'outer' dictionary, while the two items in the list must both be strings in case of
		--        the 'inner' dictionary.
		--        The 3 strings must be different and can be one of: 'file_content', 'output', 'output_history'
		--"
		--To not use any layout, specify `vim.g.jukit_layout=-1`
	end,
	config = function()
		vim.keymap.set("n", "<leader>os", function()
			-- vim.cmd("cd %:h")
			vim.cmd("call jukit#splits#output()")
		end)
		--- Opens a new output window and executes the command specified in `g:jukit_shell_cmd`
		vim.keymap.set("n", "<leader>ts", function()
			vim.cmd("call jukit#splits#term()")
		end)
		--- Opens a new output window without executing any command
		vim.keymap.set("n", "<leader>hs", function()
			vim.cmd("call jukit#splits#history()")
		end)
		--- Opens a new output-history window, where saved ipython outputs are displayed
		vim.keymap.set("n", "<leader>ohs", function()
			vim.cmd("call jukit#splits#output_and_history()")
		end)
		--- Shortcut for opening output terminal and output-history
		vim.keymap.set("n", "<leader>hd", function()
			vim.cmd("call jukit#splits#close_history()")
		end)
		--- Close output-history window
		vim.keymap.set("n", "<leader>od", function()
			vim.cmd("call jukit#splits#close_output_split()")
		end)
		--- Close output window
		vim.keymap.set("n", "<leader>ohd", function()
			vim.cmd("call jukit#splits#close_output_and_history(1)")
		end)
		--- Close both windows. Argument: Whether or not to ask you to confirm before closing.
		vim.keymap.set("n", "<leader>so", function()
			vim.cmd("call jukit#splits#show_last_cell_output(1)")
		end)
		--- Show output of current cell (determined by current cursor position) in output-history window. Argument: Whether or not to reload outputs if cell id of outputs to display is the same as the last cell id for which outputs were displayed
		-- vim.keymap.set("n", "<leader>j", function()
		-- vim.cmd("call jukit#splits#out_hist_scroll(1)")
		-- end)
		--- Scroll down in output-history window. Argument: whether to scroll down (1) or up (0)
		-- vim.keymap.set("n", "<leader>k", function()
		-- vim.cmd("call jukit#splits#out_hist_scroll(0)")
		-- end)
		--- Scroll up in output-history window. Argument: whether to scroll down (1) or up (0)
		vim.keymap.set("n", "<leader>ah", function()
			vim.cmd("call jukit#splits#toggle_auto_hist()")
		end)
		--- Create/delete autocmd for displaying saved output on CursorHold. Also, see explanation for `g:jukit_auto_output_hist`
		vim.keymap.set("n", "<leader>sl", function()
			vim.cmd("call jukit#layouts#set_layout()")
		end)
		--- Apply layout (see `g:jukit_layout`) to current splits - NOTE: it is expected that this function is called from the main file buffer/split

		--sending code

		vim.keymap.set("n", "<leader><space>", function()
			vim.cmd("call jukit#send#section(0)")
			os.execute("notify-send Done")
		end)
		--- Send code within the current cell to output split (also saves the output if ipython is used and `g:jukit_save_output==1`). Argument: if 1, will move the cursor to the next cell below after sending the code to the split, otherwise cursor position stays the same.
		-- vim.keymap.set("n", "", function()
		-- vim.cmd("call jukit#send#line()")
		-- end)
		-- --- Send current line to output split
		-- vim.keymap.set("n", "", function()
		-- vim.cmd("<C-U>call jukit#send#selection()")
		-- end)
		--- Send visually selected code to output split
		vim.keymap.set("n", "<leader>cc", function()
			vim.cmd("call jukit#send#until_current_section()")
		end)
		--- Execute all cells until the current cell
		vim.keymap.set("n", "<leader>all", function()
			vim.cmd("call jukit#send#all()")
		end)
		--- Execute all cells

		--cells

		vim.keymap.set("n", "<leader>co", function()
			vim.cmd("call jukit#cells#create_below(0)")
		end)
		--- Create new code cell below. Argument: Whether to create code cell (0) or markdown cell (1)
		vim.keymap.set("n", "<leader>cO", function()
			vim.cmd("call jukit#cells#create_above(0)")
		end)
		--- Create new code cell above. Argument: Whether to create code cell (0) or markdown cell (1)
		vim.keymap.set("n", "<leader>ct", function()
			vim.cmd("call jukit#cells#create_below(1)")
		end)
		--- Create new textcell below. Argument: Whether to create code cell (0) or markdown cell (1)
		vim.keymap.set("n", "<leader>cT", function()
			vim.cmd("call jukit#cells#create_above(1)")
		end)
		--- Create new textcell above. Argument: Whether to create code cell (0) or markdown cell (1)
		vim.keymap.set("n", "<leader>cd", function()
			vim.cmd("call jukit#cells#delete()")
		end)
		--- Delete current cell
		vim.keymap.set("n", "<leader>cs", function()
			vim.cmd("call jukit#cells#split()")
		end)
		--- Split current cell (saved output will then be assigned to the resulting cell above)
		vim.keymap.set("n", "<leader>cM", function()
			vim.cmd("call jukit#cells#merge_above()")
		end)
		--- Merge current cell with the cell above
		vim.keymap.set("n", "<leader>cm", function()
			vim.cmd("call jukit#cells#merge_below()")
		end)
		--- Merge current cell with the cell below
		vim.keymap.set("n", "<leader>ck", function()
			vim.cmd("call jukit#cells#move_up()")
		end)
		--- Move current cell up
		vim.keymap.set("n", "<leader>cj", function()
			vim.cmd("call jukit#cells#move_down()")
		end)
		--- Move current cell down
		vim.keymap.set("n", "<leader>J", "<cmd>call jukit#cells#jump_to_next_cell()<cr>zz")
		--- Jump to the next cell below
		vim.keymap.set("n", "<leader>K", "<cmd>call jukit#cells#jump_to_previous_cell()<cr>zz")
		--- Jump to the previous cell above
		vim.keymap.set("n", "<leader>ddo", function()
			vim.cmd("call jukit#cells#delete_outputs(0)")
		end)
		--- Delete saved output of current cell. Argument: Whether to delete all saved outputs (1) or only saved output of current cell (0)
		vim.keymap.set("n", "<leader>dda", function()
			vim.cmd("call jukit#cells#delete_outputs(1)")
		end)
		--- Delete saved outputs of all cells. Argument: Whether to delete all saved outputs (1) or only saved output of current cell (0)

		-- ipynp conversion

		vim.keymap.set("n", "<leader>np", function()
			vim.cmd("call jukit#convert#notebook_convert('jupyter-notebook')")
		end)
		--- Convert from ipynb to py or vice versa. Argument: Optional. If an argument is specified, then its value is used to open the resulting ipynb file after converting script.
		vim.keymap.set("n", "<leader>ht", function()
			vim.cmd("call jukit#convert#save_nb_to_file(0,1,'html')")
		end)
		--- Convert file to html (including all saved outputs) and open it using the command specified in `g:jukit_html_viewer'. If `g:jukit_html_viewer` is not defined, then will default to `g:jukit_html_viewer='xdg-open'`. Arguments: 1.: Whether to rerun all cells when converting 2.: Whether to open it after converting 3.: filetype to convert to
		vim.keymap.set("n", "<leader>rht", function()
			vim.cmd("call jukit#convert#save_nb_to_file(1,1,'html')")
		end)
		--- same as above, but will (re-)run all cells when converting to html
		-- vim.keymap.set("n","<leader>pd",function()
		-- vim.cmd("call jukit#convert#save_nb_to_file(0,1,'pdf')")
		-- end)
		--- Convert file to pdf (including all saved outputs) and open it using the command specified in `g:jukit_pdf_viewer'. If `g:jukit_pdf_viewer` is not defined, then will default to `g:jukit_pdf_viewer='xdg-open'`. Arguments: 1.: Whether to rerun all cells when converting 2.: Whether to open it after converting 3.: filetype to convert to. NOTE: If the function doesn't work there may be issues with your nbconvert or latex version - to debug, try converting to pdf using `jupyter nbconvert --to pdf --allow-errors --log-level='ERROR' --HTMLExporter.theme=dark </abs/path/to/ipynb> && xdg-open </abs/path/to/pdf>` in your terminal and check the output for possible issues.
		vim.keymap.set("n", "<leader>rpd", function()
			vim.cmd("call jukit#convert#save_nb_to_file(1,1,'pdf')")
		end)
		--- same as above, but will (re-)run all cells when converting to pdf. NOTE: If the function doesn't work there may be issues with your nbconvert or latex version - to debug, try converting to pdf using `jupyter nbconvert --to pdf --allow-errors --log-level='ERROR' --HTMLExporter.theme=dark </abs/path/to/ipynb> && xdg-open </abs/path/to/pdf>` in your terminal and check the output for possible issues.
	end,
}
