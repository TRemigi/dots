require("plugins.telescope")
require("plugins.dressing")

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
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function()
      require('plugins.telescope') -- Load telescope configuration
    end
  }

  use {
    "hrsh7th/nvim-cmp",
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      require('luasnip.loaders.from_vscode').lazy_load()

      cmp.setup({
	completion = {
	  completeopt = 'menu,menuone,preview,noselect',
	},
	snippet = {
	  expand = function(args)
	    luasnip.lsp_expand(args.body)
	  end,
	},
	mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(),
	  ["<C-j>"] = cmp.mapping.select_next_item(),
	  ["C-b>"] = cmp.mapping.scroll_docs(-4),
	  ["<C-f>"] = cmp.mapping.scroll_docs(4),
	  ["<C-space>"] = cmp.mapping.complete(),
	  ["<C-e>"] = cmp.mapping.abort(),
	  ["<CR>"] = cmp.mapping.confirm({ select = false }),
	}),
	sources = cmp.config.sources({
          { name = 'luasnip' },
	  { name = 'buffer' },
	  { name = 'path' },
	}),
      })
    end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

