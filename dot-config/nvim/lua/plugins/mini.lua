return {
  "nvim-mini/mini.nvim",
  version = "*",
  config = function()
    require("mini.ai").setup()
    require("mini.splitjoin").setup()
    require("mini.operators").setup()
  end,
}
