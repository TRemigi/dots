return {
	"theHamsta/nvim-dap-virtual-text",
	config = function()
		require("nvim-dap-virtual-text").setup({
			commented = false,
		})
	end,
	keys = {
		{
			"<leader>dt",
			"<cmd>DapVirtualTextToggle<cr>",
			mode = "n",
			desc = "DAP toggle virtual text",
		},
	},
}
