return {
	"echasnovski/mini.nvim",
	version = "*",
	config = function()
		require("mini.comment").setup()
		require("mini.move").setup()
		require("mini.pairs").setup()
		require("mini.splitjoin").setup()
		require("mini.surround").setup()
		require("mini.icons").setup()
		require("mini.diff").setup()
	end,
}
