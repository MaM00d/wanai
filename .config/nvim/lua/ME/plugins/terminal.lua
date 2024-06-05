return {
	"akinsho/toggleterm.nvim",

	version = "*",
	keys = {
		{
			"<A-t>",
			mode = "t",
			function()
				vim.cmd("ToggleTermToggleAll")
			end,
		},
		{
			"<A-t>",
			function()
				-- vim.cmd("cd %:h")
				vim.cmd("3ToggleTerm size=20 go_back=0 dir=% direction=horizontal name=Terminal")
			end,
		},

		--running
		-- {
		-- 	"<A-t>",
		--
		-- 	function()
		-- 		require("toggleterm").setup({
		-- 			size = function(term)
		-- 				if term.direction == "horizontal" then
		-- 					return o.lines * 0.4
		-- 				elseif term.direction == "vertical" then
		-- 					return o.columns * 0.5
		-- 				elseif term.direction == "tab" then
		-- 					return o.columns
		-- 				end
		-- 			end,
		-- 			hide_numbers = true,
		-- 			shade_filetypes = {},
		-- 			shade_terminals = false,
		-- 			start_in_insert = true,
		-- 			insert_mappings = false,
		-- 			terminal_mappings = true,
		-- 			persist_mode = false,
		-- 			persist_size = false,
		-- 		})
		-- 	end,
		-- },
		{
			"<A-r>",
			function()
				Filetype = vim.bo.filetype
				print(Filetype)

				if Filetype == "dart" then
					vim.cmd("FlutterRun")
				else
					vim.cmd("w")
					vim.cmd("cd %:h")
					local term

					if Filetype == "c" then
						--normal c console build run
						term = "gcc  -I /home/me/.data/clang/libs % -o %:r && ./%:r"
					--embedded c build run burn on atmega32
					-- "avr-gcc -std=c99 -o %:p:h\\main.elf % && avr-objcopy %:p:h\\main.elf -O ihex %:p:h\\main.hex && avrdude -c avrisp -p m32 -U flash:w:%:p:h\\main.hex"
					elseif Filetype == "python" then
						term = "python %"
					elseif Filetype == "rust" then
						term = "cargo run"
					elseif Filetype == "cs" then
						term = "dotnet run"
					elseif Filetype == "cpp" then
						term = "sudo g++ -o %:r % -fopenmp && sudo ./%:r"
					elseif Filetype == "markdown" then
						vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
					end
					if term ~= nil then
						local x = '2TermExec dir=% cmd="' .. term .. '" direction=horizontal size=30 name=run'
						vim.cmd(x)
					end
				end
			end,
		},
	},
	config = true,
}
