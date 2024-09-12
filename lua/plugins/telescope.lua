local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
  defaults = {
    mappings = {
      i = {
	["<C-k>"] = actions.move_selection_previous,
	["<C-j>"] = actions.move_selection_next,
	["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
      }
    }
  }
});

telescope.load_extension("fzf")

-- Key maps
vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files({ hidden = true })<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>of', "<cmd>lua require('telescope.builtin').oldfiles()<CR>", { noremap = true, silent = true })
