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
	init = function()
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.dadbod_mysql_cli = "mariadb"

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
