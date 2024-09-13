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
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  }
  
  require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
	"tsserver",
	"html",
	"cssls",
	"tailwindcss",
	"lua_ls",
	"angularls",
	"bashls",
	"cssls",
	"ast_grep",
	"docker",
	"jsonls",
	"marksman",
	"intelephense",
	"vuels",
	"yamlls",
	"typos_lsp",
      }
    })

    require("mason-lspconfig").setup_handlers {
      -- The first entry (without a key) will be the default handler
      -- and will be called for each installed server that doesn't have
      -- a dedicated handler.
      function (server_name) -- default handler (optional)
	  require("lspconfig")[server_name].setup {}
      end,
      -- Next, you can provide a dedicated handler for specific servers.
      -- For example, a handler override for the `rust_analyzer`:
      ["rust_analyzer"] = function ()
	  require("rust-tools").setup {}
      end
    }
    
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end

end)

