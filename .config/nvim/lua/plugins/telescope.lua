return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local transform_mod = require("telescope.actions.mt").transform_mod

		local trouble = require("trouble")
		local trouble_telescope = require("trouble.sources.telescope")

		-- or create your custom action
		local custom_actions = transform_mod({
			open_trouble_qflist = function(prompt_bufnr)
				trouble.open("qflist")
			end,
		})

		telescope.setup({
			defaults = {
				layout_config = {
					horizontal = { width = 0.95 },
					vertical = { width = 0.95 },
				},
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.add_selected_to_qflist,
						["<C-a>"] = actions.send_to_qflist,
						["<C-t>"] = trouble_telescope.open,
					},
				},
			},
			pickers = {
				find_files = {
					hidden = true,
          no_ignore = false,
				},
				live_grep = {
					hidden = true,
          no_ignore = true,
				},
				current_buffer_fuzzy_find = {
					tiebreak = function(current_entry, existing_entry)
						-- returning true means preferring current entry
						return current_entry.lnum < existing_entry.lnum
					end,
				},
			},
		})

		telescope.load_extension("fzf")
	end,
}
