return {
	"KabbAmine/zeavim.vim",
	keys = {
		{
			mode = "n",
			"<leader>k",
			function()
				vim.cmd("Zeavim!")
			end,
			desc = "Search Zeal docsets",
		},
	},
}
