return {
	"mfussenegger/nvim-dap",
	config = function()
		local dap = require("dap")
		-- require("telescope").load_extension("dap")

		dap.adapters.php = {
			type = "executable",
			command = "node",
			args = { os.getenv("HOME") .. "/vscode-php-debug/out/phpDebug.js" },
		}

		dap.configurations.php = {
			{
				type = "php",
				request = "launch",
				name = "Listen for Xdebug",
				port = 9003,
			},
		}

		local keymap = vim.keymap
		keymap.set("n", "<leader>dc", function()
			dap.continue()
		end)
		keymap.set("n", "<leader>do", function()
			dap.step_over()
		end)
		keymap.set("n", "<leader>di", function()
			dap.step_into()
		end)
		keymap.set("n", "<leader>dO", function()
			dap.step_out()
		end)
		keymap.set("n", "<leader>b", function()
			dap.toggle_breakpoint()
		end)
		keymap.set("n", "<leader>B", function()
			dap.set_breakpoint()
		end)
		keymap.set("n", "<leader>lp", function()
			dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
		end)
		keymap.set("n", "<leader>dr", function()
			dap.repl.open()
		end)
		keymap.set("n", "<leader>dl", function()
			dap.run_last()
		end)
		keymap.set({ "n", "v" }, "<leader>dh", function()
			dap.ui.widgets.hover()
		end)
		keymap.set({ "n", "v" }, "<leader>dp", function()
			dap.ui.widgets.preview()
		end)
		keymap.set("n", "<leader>df", function()
			local widgets = dap.ui.widgets
			widgets.centered_float(widgets.frames)
		end)
		keymap.set("n", "<leader>ds", function()
			local widgets = dap.ui.widgets
			widgets.centered_float(widgets.scopes)
		end)
	end,
}
