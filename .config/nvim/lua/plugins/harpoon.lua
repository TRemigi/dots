return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")

		harpoon:setup()
		vim.keymap.set("n", "<leader>ha", function()
			harpoon:list():add()
		end)
		vim.keymap.set("n", "<leader>hh", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end)

		vim.keymap.set("n", "<leader>h1", function()
			harpoon:list():select(1)
		end, { desc = "Select harpon list index 1"})
		vim.keymap.set("n", "<leader>h2", function()
			harpoon:list():select(2)
		end, { desc = "Select harpon list index 2"})
		vim.keymap.set("n", "<leader>h3", function()
			harpoon:list():select(3)
		end, { desc = "Select harpoon list index 3"})
		vim.keymap.set("n", "<leader>h4", function()
			harpoon:list():select(4)
		end, { desc = "Select harpoon list index 4"})
		vim.keymap.set("n", "<leader>h5", function()
			harpoon:list():select(5)
		end, { desc = "Select harpoon list index 5"})
		vim.keymap.set("n", "<leader>h6", function()
			harpoon:list():select(6)
		end, { desc = "Select harpoon list index 6"})
		vim.keymap.set("n", "<leader>h7", function()
			harpoon:list():select(7)
		end, { desc = "Select harpoon list index 7"})
		vim.keymap.set("n", "<leader>h8", function()
			harpoon:list():select(8)
		end, { desc = "Select harpoon list index 8"})
		vim.keymap.set("n", "<leader>h9", function()
			harpoon:list():select(9)
		end, { desc = "Select harpoon list index 9"})

		-- Toggle previous & next buffers stored within Harpoon list
		vim.keymap.set("n", "<C-e>", function()
			harpoon:list():prev()
		end, { desc = "Previous harpoon buffer"})
		vim.keymap.set("n", "<C-n>", function()
			harpoon:list():next()
		end, { desc = "Next harpoon buffer"})
	end,
}
