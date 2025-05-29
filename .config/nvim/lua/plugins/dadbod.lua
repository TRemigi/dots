return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
	},
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	keys = {
		{ "<leader>mu", "<cmd>DBUIToggle<CR>", desc = "Toggle DB UI" },
		{ "<leader>mr", "<cmd>DB<CR>", desc = "Run SQL query" },
		{ "<leader>ma", "<cmd>DBUIAddConnection<CR>", desc = "Add DB connection" },
		{ "<leader>mf", "<cmd>DBUIFindBuffer<CR>", desc = "Find DB buffer" },
		{
			"<leader>mt",
			function()
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					local name = vim.api.nvim_buf_get_name(buf)
					if name:match("^dbui:///results") then
						if vim.api.nvim_buf_is_loaded(buf) then
							for _, win in ipairs(vim.api.nvim_list_wins()) do
								if vim.api.nvim_win_get_buf(win) == buf then
									vim.api.nvim_win_close(win, true)
									return
								end
							end
							vim.cmd("sbuffer " .. buf)
							return
						end
					end
				end
			end,
			desc = "Toggle DBUI Results Buffer",
		},
	},
	config = function()
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.dadbod_mysql_cli = "mariadb"
		local ok = pcall(require, "lazy.core.loader")
		if ok then
			require("lazy.core.loader").load("vim-dadbod-completion")
		end

		--- Helper to get pass secret
		local function get_pass_connection(path)
			local handle = io.popen("pass " .. path)
			if not handle then
				return nil
			end
			local result = handle:read("*a")
			handle:close()
			return result and result:gsub("%s+$", "") or nil
		end

		local connections = {}
		local ok, result = pcall(dofile, vim.fn.expand("~/.config/nvim/local/dadbod-connections.lua"))
		if ok then
			connections = result
		else
			vim.notify("Failed to load local dadbod connections: " .. result, vim.log.levels.ERROR)
		end

		local dbs = {}

		for _, conn in ipairs(connections) do
			local conn_str = get_pass_connection(conn.path)
			if conn_str and conn_str ~= "" then
				table.insert(dbs, {
					name = conn.name,
					url = conn_str,
				})
			end
		end

		vim.g.dbs = dbs
	end,
}
