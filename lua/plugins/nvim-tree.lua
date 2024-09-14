return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
        vim.g.nvim_tree_quit_on_open = 1
    require("nvim-tree").setup {}
  end,
}
