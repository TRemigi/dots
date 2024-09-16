return {
  'lewis6991/gitsigns.nvim',
  config = function()
    require('gitsigns').setup({
      current_line_blame = true,  -- Enable inline git blame
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      current_line_blame_opts = {
        delay = 1000,  -- Delay before showing the blame info
      },
      current_line_blame_formatter_opts = {
        relative_time = true,  -- Use relative time in blame info
      },
    })
end,
}
