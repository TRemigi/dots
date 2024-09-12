-- Bootstrap Packer
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Autocommand that reloads neovim whenever you save the init.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerSync
  augroup end
]])

-- Vim configurations
vim.cmd.colorscheme("oldworld")
vim.g.mapleader = " "
vim.wo.relativenumber = true
vim.opt.number = true
vim.opt.shiftwidth = 2
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

-- Theme setup

-- Telescope
local builtin = require('telescope.builtin')
vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files({ hidden = true })<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>of', "<cmd>lua require('telescope.builtin').oldfiles()<CR>", { noremap = true, silent = true })

-- Use a protected call so we don’t error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Initialize packer
return packer.startup(function(use)
  -- Theme
  use { "dgox16/oldworld.nvim" }

  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Example: Lualine (statusline)
  use 'nvim-lualine/lualine.nvim'

  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})

  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

