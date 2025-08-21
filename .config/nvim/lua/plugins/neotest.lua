return {
	"nvim-neotest/neotest",
  version = "v5.2.5",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"olimorris/neotest-phpunit",
		"thenbe/neotest-playwright",
		{ "nvim-neotest/neotest-jest", commit = "514fd4eae7da15fd409133086bb8e029b65ac43f" },
		{ "fredrikaverpil/neotest-golang", version = "*" },
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-jest")({
					jestCommand = "npm test -- --maxWorkers=1",
					jest_test_discovery = true,
					jestConfigFile = vim.fn.getcwd() .. "/jest.config.ts",
					env = { ENVIRONMENT = "development" },
					cwd = function()
						return vim.fn.getcwd()
					end,
				}),
				require("neotest-playwright").adapter({
					options = {
						persist_project_selection = true,
						enable_dynamic_test_discovery = true,
					},
				}),
				require("neotest-golang")({
					runner = "gotestsum",
				}),
				require("neotest-phpunit")({
					phpunit_cmd = function()
						return "docker-test-php"
					end,
					cwd = function()
						return "/app"
					end,
				}),
			},
			benchmark = {
				enabled = true,
			},
			consumers = {},
			default_strategy = "integrated",
			diagnostic = {
				enabled = true,
				severity = 1,
			},
			discovery = {
				concurrent = 0,
				enabled = true,
			},
			floating = {
				max_height = 0.6,
				max_width = 0.6,
				options = {},
			},
			highlights = {
				adapter_name = "NeotestAdapterName",
				border = "NeotestBorder",
				dir = "NeotestDir",
				expand_marker = "NeotestExpandMarker",
				failed = "NeotestFailed",
				file = "NeotestFile",
				focused = "NeotestFocused",
				indent = "NeotestIndent",
				marked = "NeotestMarked",
				namespace = "NeotestNamespace",
				passed = "NeotestPassed",
				running = "NeotestRunning",
				select_win = "NeotestWinSelect",
				skipped = "NeotestSkipped",
				target = "NeotestTarget",
				test = "NeotestTest",
				unknown = "NeotestUnknown",
				watching = "NeotestWatching",
			},
			icons = {
				child_indent = "│",
				child_prefix = "├",
				collapsed = "─",
				expanded = "╮",
				failed = "",
				final_child_indent = " ",
				final_child_prefix = "╰",
				non_collapsible = "─",
				notify = "",
				passed = "",
				running = "",
				running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
				skipped = "",
				unknown = "",
				watching = "",
			},
			jump = {
				enabled = true,
			},
			log_level = 3,
			output = {
				enabled = true,
				open_on_run = "short",
			},
			output_panel = {
				enabled = true,
				open = "botright split | resize 15",
			},
			projects = {},
			quickfix = {
				enabled = true,
				open = false,
			},
			run = {
				enabled = true,
			},
			running = {
				concurrent = true,
			},
			state = {
				enabled = true,
			},
			status = {
				enabled = true,
				signs = true,
				virtual_text = false,
			},
			strategies = {
				integrated = {
					height = 40,
					width = 120,
				},
			},
			summary = {
				animated = true,
				count = true,
				enabled = true,
				expand_errors = true,
				follow = true,
				mappings = {
					attach = "a",
					clear_marked = "M",
					clear_target = "T",
					debug = "d",
					debug_marked = "D",
					expand = { "<CR>", "<2-LeftMouse>" },
					expand_all = "e",
					help = "?",
					jumpto = "i",
					mark = "m",
					next_failed = "J",
					output = "o",
					prev_failed = "K",
					run = "r",
					run_marked = "R",
					short = "O",
					stop = "u",
					target = "t",
					watch = "w",
				},
				open = "botright vsplit | vertical resize 50",
			},
			watch = {
				enabled = true,
				symbol_queries = {
					go = "        ;query\n        ;Captures imported types\n        (qualified_type name: (type_identifier) @symbol)\n        ;Captures package-local and built-in types\n        (type_identifier)@symbol\n        ;Captures imported function calls and variables/constants\n        (selector_expression field: (field_identifier) @symbol)\n        ;Captures package-local functions calls\n        (call_expression function: (identifier) @symbol)\n      ",
					haskell = "        ;query\n        ;explicit import\n        ((import_item [(variable)]) @symbol)\n        ;symbols that may be imported implicitly\n        ((type) @symbol)\n        (qualified_variable (variable) @symbol)\n        (exp_apply (exp_name (variable) @symbol))\n        ((constructor) @symbol)\n        ((operator) @symbol)\n      ",
					java = "        ;query\n        ;captures imported classes\n        (import_declaration\n            (scoped_identifier name: ((identifier) @symbol))\n        )\n      ",
					javascript = '  ;query\n  ;Captures named imports\n  (import_specifier name: (identifier) @symbol)\n  ;Captures default import\n  (import_clause (identifier) @symbol)\n  ;Capture require statements\n  (variable_declarator \n  name: (identifier) @symbol\n  value: (call_expression (identifier) @function  (#eq? @function "require")))\n  ;Capture namespace imports\n  (namespace_import (identifier) @symbol)\n',
					lua = '        ;query\n        ;Captures module names in require calls\n        (function_call\n          name: ((identifier) @function (#eq? @function "require"))\n          arguments: (arguments (string) @symbol))\n      ',
					python = "        ;query\n        ;Captures imports and modules they're imported from\n        (import_from_statement (_ (identifier) @symbol))\n        (import_statement (_ (identifier) @symbol))\n      ",
					ruby = '        ;query\n        ;rspec - class name\n        (call\n          method: (identifier) @_ (#match? @_ "^(describe|context)")\n          arguments: (argument_list (constant) @symbol )\n        )\n\n        ;rspec - namespaced class name\n        (call\n          method: (identifier)\n          arguments: (argument_list\n            (scope_resolution\n              name: (constant) @symbol))\n        )\n      ',
					rust = "        ;query\n        ;submodule import\n        (mod_item\n          name: (identifier) @symbol)\n        ;single import\n        (use_declaration\n          argument: (scoped_identifier\n            name: (identifier) @symbol))\n        ;import list\n        (use_declaration\n          argument: (scoped_use_list\n            list: (use_list\n                [(scoped_identifier\n                   path: (identifier)\n                   name: (identifier) @symbol)\n                 ((identifier) @symbol)])))\n        ;wildcard import\n        (use_declaration\n          argument: (scoped_use_list\n            path: (identifier)\n            [(use_list\n              [(scoped_identifier\n                path: (identifier)\n                name: (identifier) @symbol)\n                ((identifier) @symbol)\n              ])]))\n      ",
					tsx = '  ;query\n  ;Captures named imports\n  (import_specifier name: (identifier) @symbol)\n  ;Captures default import\n  (import_clause (identifier) @symbol)\n  ;Capture require statements\n  (variable_declarator \n  name: (identifier) @symbol\n  value: (call_expression (identifier) @function  (#eq? @function "require")))\n  ;Capture namespace imports\n  (namespace_import (identifier) @symbol)\n',
					typescript = '  ;query\n  ;Captures named imports\n  (import_specifier name: (identifier) @symbol)\n  ;Captures default import\n  (import_clause (identifier) @symbol)\n  ;Capture require statements\n  (variable_declarator \n  name: (identifier) @symbol\n  value: (call_expression (identifier) @function  (#eq? @function "require")))\n  ;Capture namespace imports\n  (namespace_import (identifier) @symbol)\n',
				},
			},
		})

		-- Because we're running tests in a container, the output doesn't make it back
		-- to neotest in a way it expects. Prevent notifications about missing output.
		local notify = require("neotest.lib").notify
		require("neotest.lib").notify = function(msg, level)
			if msg:match("^No output for ") then
				return
			end
			notify(msg, level)
		end

		-- command to toggle watching the current buffer and run the test file selected in snacks picker
		local active_watchers = {}
		local function sanitize_autocmd_name(path)
			return "NeotestWatch_" .. path:gsub("[^%w_]", "_")
		end

		local function get_all_php_test_files()
			local scan = require("plenary.scandir")
			return scan.scan_dir("./tests", { hidden = false, depth = 10, add_dirs = false })
		end

		local function toggle_watch_for_current_php_buffer()
			local buf_path = vim.api.nvim_buf_get_name(0)
			local augroup_name = sanitize_autocmd_name(buf_path)

			if active_watchers[buf_path] then
				vim.api.nvim_del_augroup_by_name(augroup_name)
				active_watchers[buf_path] = nil
				vim.notify("❌ Stopped watching: " .. buf_path)
				return
			end

			local test_files = get_all_php_test_files()
			if vim.tbl_isempty(test_files) then
				vim.notify("⚠️ No test files found in ./tests")
				return
			end

			require("snacks.picker").select(test_files, {
				prompt = "Select test file to run on save",
				format_item = function(item)
					return vim.fn.fnamemodify(item, ":~:.") -- shorter path
				end,
			}, function(test_path)
				if not test_path then
					vim.notify("⚠️ No test selected")
					return
				end

				local short_test = vim.fn.fnamemodify(test_path, ":t")

				vim.api.nvim_create_augroup(augroup_name, { clear = true })
				vim.api.nvim_create_autocmd("BufWritePost", {
					group = augroup_name,
					pattern = buf_path,
					callback = function()
						local neotest = require("neotest")
						neotest.run.run(test_path)
						vim.notify("🌀 Running test " .. short_test)

						-- Show output window after slight delay (test has to initialize)
						vim.defer_fn(function()
							neotest.output_panel.open()
						end, 2000) -- delay in milliseconds
					end,
				})

				active_watchers[buf_path] = test_path

				local short_buf = vim.fn.fnamemodify(buf_path, ":t")
				vim.notify("✅ Watching " .. short_buf .. " → running " .. short_test .. " on save")
			end)
		end

		-- keymaps
		vim.keymap.set("n", "<leader>tw", toggle_watch_for_current_php_buffer, {
			desc = "Neotest: Watch current file and run selected test on save",
		})

		vim.keymap.set("n", "<leader>tt", function()
			require("neotest").run.run()
			vim.defer_fn(function()
				require("neotest").output.open({ enter = false })
			end, 100) -- slight delay ensures output is available
		end, { desc = "Neotest: Run nearest test and show output" })

		vim.keymap.set("n", "<leader>tf", function()
			require("neotest").run.run(vim.fn.expand("%"))
			vim.defer_fn(function()
				require("neotest").output.open({ enter = false })
			end, 100)
		end, { desc = "Neotest: Run file tests and show output" })

		vim.keymap.set("n", "<leader>ts", function()
			require("neotest").summary.toggle()
		end, { desc = "Neotest: Toggle summary panel" })

		vim.keymap.set("n", "<leader>to", function()
			require("neotest").output.open({ enter = false })
		end, { desc = "Neotest: Open test output window" })

		vim.keymap.set("n", "<leader>tp", function()
			require("neotest").output_panel.toggle()
		end, { desc = "Neotest: Toggle output panel" })

		vim.keymap.set("n", "<leader>tl", function()
			require("neotest").run.run_last()
		end, { desc = "Neotest: Run last test" })

		vim.keymap.set("n", "<leader>tx", function()
			require("neotest").run.stop()
		end, { desc = "Neotest: Stop running test(s)" })
	end,
}
