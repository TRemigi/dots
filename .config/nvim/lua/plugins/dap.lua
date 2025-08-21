return {
	"mfussenegger/nvim-dap",
	dependencies = {
		{
			---@module 'dap-view'
			---@type dapview.Config
			"igorlfs/nvim-dap-view",
			opts = {
				windows = {
					terminal = {
						-- Use the actual names for the adapters you want to hide
						hide = { "go", "php" }, -- `go` is known to not use the terminal.
					},
				},
			},
		},
		"nvim-neotest/nvim-nio",
	},
	config = function()
		vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
		vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })

		local dap, dv = require("dap"), require("dap-view")
		dap.listeners.before.attach["dap-view-config"] = function()
			dv.open()
		end
		dap.listeners.before.launch["dap-view-config"] = function()
			dv.open()
		end
		dap.listeners.before.event_terminated["dap-view-config"] = function()
			dv.close()
		end
		dap.listeners.before.event_exited["dap-view-config"] = function()
			dv.close()
		end

		dap.adapters.php = {
			type = "executable",
			command = "node",
			args = { os.getenv("HOME") .. "/vscode-php-debug/out/phpDebug.js" },
		}
		dap.adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = "node",
				args = { "/path/to/js-debug/src/dapDebugServer.js", "${port}" },
			},
		}

		dap.configurations.javascript = {
			{
				type = "pwa-node",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				cwd = "${workspaceFolder}",
			},
		}
		dap.configurations.php = {
			{
				type = "php",
				request = "launch",
				name = "Listen for Xdebug",
				port = 9003,
				pathMappings = {
					["/app"] = vim.fn.getcwd(), -- or the actual host path to your Laravel project
				},
			},
		}

		dv.setup()
	end,
	keys = {
		{
			"<leader>dc",
			function()
				require("dap").continue()
			end,
			desc = "DAP continue",
		},
		{
			"<leader>dv",
			function()
				require("dap-view").toggle(true)
			end,
			desc = "DAP view open",
		},
		{
			"<leader>do",
			function()
				require("dap").step_over()
			end,
			desc = "DAP step over",
		},
		{
			"<leader>di",
			function()
				require("dap").step_into()
			end,
			desc = "DAP step into",
		},
		{
			"<leader>dO",
			function()
				require("dap").step_out()
			end,
			desc = "DAP step out",
		},
		{
			"<leader>b",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "DAP toggle breakpoint",
		},
		{
			"<leader>B",
			function()
				require("dap").set_breakpoint()
			end,
			desc = "DAP set breakpoint",
		},
		{
			"<leader>lp",
			function()
				require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end,
			desc = "DAP log point message",
		},
		{
			"<leader>dr",
			function()
				require("dap").repl.open()
			end,
			desc = "DAP open repl",
		},
		{
			"<leader>dl",
			function()
				require("dap").run_last()
			end,
			desc = "DAP run last",
		},
	},
}
