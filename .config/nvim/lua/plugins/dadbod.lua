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
	},
	config = function()
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.dadbod_mysqlcli = "mariadb"
		vim.g.dadbod_cli_aliases = {
		  mysql = "mariadb"
		}
		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "*.sql",
			callback = function()
				if vim.b.db and vim.b.db:match("^mysql://") then
					vim.bo.filetype = "mysql"
				end
			end,
		})

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

		-- Connections are defined in untracked file ~/.config/nvim/local/dadbod-connections.lua
		-- Connectiton URLs are stored securely using the "pass" package.
		-- Each connection provides a connection name and the "pass" path to the connection URL.
		-- Connections format:
		--   return {
		--     { name = "local_optimus", path = "mysql/dev/optimus" },
		--   }
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
