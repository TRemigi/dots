require("core")
require("config.lazy")

local opt = vim.opt

-- Vim configurations
vim.api.nvim_set_keymap("n", "<leader>w", ":set wrap!<CR>", { noremap = true, silent = true })
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "
vim.wo.relativenumber = true
opt.number = true
opt.cursorline = true
opt.cursorlineopt = "number"
-- vim.diagnostic.config({
-- 	-- Use the default configuration
-- 	-- virtual_lines = true
--
-- 	-- Alternatively, customize specific options
-- 	virtual_lines = {
-- 		-- Only show virtual line diagnostics for the current cursor line
-- 		current_line = true,
-- 	},
-- })

-- fold
opt.foldenable = false
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldlevelstart = 2
opt.foldnestmax = 4
opt.foldcolumn = "0"

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
--
-- opt.autoindent = true -- copy indent from current line when starting new one
opt.smartindent = true
opt.swapfile = false
opt.incsearch = true
opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom
