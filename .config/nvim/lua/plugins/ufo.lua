return {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async",
  },
  event = "BufReadPost",
  config = function()
    -- General fold settings
    vim.o.foldcolumn = '1'
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    -- Keymaps for opening/closing all folds
    vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = "Open all folds" })
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = "Close all folds" })

    -- Enhance LSP capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true
    }

    -- Add folding capabilities to existing LSP servers
    for _, client in ipairs(vim.lsp.get_clients()) do
      require('lspconfig')[client.name].setup {
        capabilities = capabilities,
      }
    end

    require("ufo").setup()
  end
}
