return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"olimorris/neotest-phpunit",
		"thenbe/neotest-playwright",
		"nvim-neotest/neotest-jest",
		{ "fredrikaverpil/neotest-golang", version = "*" },
	},
	config = function()
		require("neotest").setup({
			discovery = {
				enabled = false,
			},
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
				icons = {
					passed = "",
					failed = "",
				},
			},
			log_level = vim.log.levels.WARN,
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
