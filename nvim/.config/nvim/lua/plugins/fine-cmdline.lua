return {
	"VonHeikemen/fine-cmdline.nvim",
	"MunifTanjim/nui.nvim",
	config = function()
		require("fine-cmdline").setup({
			popup = {
				position = {
					row = "80%",
					col = "50%",
				},
				size = {
					width = "60%",
				},
				border = {
					style = "rounded",
				},
				win_options = {
					winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
				},
			},
		})
	end,
}
