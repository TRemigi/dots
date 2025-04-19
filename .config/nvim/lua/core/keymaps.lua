vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- find and replace in file
vim.api.nvim_create_user_command('Fr', function()
  -- Prompt the user for the search string
  local search = vim.fn.input('Find: ')
  -- Prompt the user for the replacement string
  local replace = vim.fn.input('Replace with: ')
  -- Perform the search and replace
  vim.cmd(string.format("%%s/%s/%s/g", search, replace))
end, {desc = 'Find and replace in file'})

-- find and replace WORD under cursor
vim.api.nvim_create_user_command('Frw', function()
  -- Get the WORD under the cursor
  local word = vim.fn.expand('<cword>')
  -- Prompt the user for the replacement string
  local replace = vim.fn.input('Replace "' .. word .. '" with: ')
  -- Perform the search and replace
  vim.cmd(string.format("%%s/\\<%s\\>/%s/g", word, replace))
end, {desc = 'Find and replace WORD under cursor in file'})

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>X", "<cmd>:!chmod +x %<CR>", { desc = "Make current file executable", noremap = true, silent = true })
keymap.set("n", "<C-g>", ":silent !tmux neww tmux-sessionizer<CR>", { desc = "Open new tmux session after fuzzy-finding directory", noremap = true, silent = true })
keymap.set("n", "<leader>ww", ":w<CR>", { desc = "Write file", noremap = true, silent = true })
keymap.set("n", "<leader>qq", ":q<CR>", { desc = "Quit buffer", noremap = true, silent = true })

-- file management
keymap.set('n', '<leader>df', ':!rm %<CR>:bd!<CR>', { desc = "Delete current file and buffer", noremap = true, silent = true })
keymap.set('n', '<leader>go', ':!go build %<CR>', { desc = "Build current go module", noremap = true, silent = true })
keymap.set('n', '<leader>gx', ':vsplit | vertical resize 40 | terminal bash -c "%:t:r; exec bash"<CR>', { desc = "Execute go package with name matching current file", noremap = true, silent = true })
