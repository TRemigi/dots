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

		-- set keymaps
		local keymap = vim.keymap -- for conciseness
		local builtin = require("telescope.builtin")

		keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
		keymap.set("n", "<leader>fC", builtin.commands, { desc = "Telescope commands" })
		keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find)
		keymap.set("n", "<leader>fc", builtin.grep_string)
		keymap.set("n", "<leader>fq", builtin.quickfix)
		keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Telescope git status" })
		keymap.set("n", "<leader>gh", builtin.git_stash, { desc = "Telescope git stash" })
		keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Telescope git branches" })
		keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Telescope git commits" })
		keymap.set("n", "<leader>ds", builtin.lsp_document_symbols, { desc = "Telescope document symbols" })
		keymap.set("n", "<leader>fm", builtin.man_pages, { desc = "Telescope man pages" })
	end,
}
