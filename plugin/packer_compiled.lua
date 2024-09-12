-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/taylorremigi/.cache/nvim/packer_hererocks/2.1.1725453128/share/lua/5.1/?.lua;/Users/taylorremigi/.cache/nvim/packer_hererocks/2.1.1725453128/share/lua/5.1/?/init.lua;/Users/taylorremigi/.cache/nvim/packer_hererocks/2.1.1725453128/lib/luarocks/rocks-5.1/?.lua;/Users/taylorremigi/.cache/nvim/packer_hererocks/2.1.1725453128/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/taylorremigi/.cache/nvim/packer_hererocks/2.1.1725453128/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  LuaSnip = {
    loaded = true,
    path = "/Users/taylorremigi/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/Users/taylorremigi/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/Users/taylorremigi/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/Users/taylorremigi/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/Users/taylorremigi/.local/share/nvim/site/pack/packer/start/friendly-snippets",
    url = "https://github.com/rafamadriz/friendly-snippets"
  },
  ["lualine.nvim"] = {
    loaded = true,
    path = "/Users/taylorremigi/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["nvim-cmp"] = {
    config = { "\27LJ\2\n-\0\1\4\1\2\0\5-\1\0\0009\1\0\0019\3\1\0B\1\2\1K\0\1\0\1À\tbody\15lsp_expandß\5\1\0\v\0$\0F6\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0026\2\0\0'\4\3\0B\2\2\0029\2\4\2B\2\1\0019\2\5\0005\4\a\0005\5\6\0=\5\b\0045\5\n\0003\6\t\0=\6\v\5=\5\f\0049\5\r\0009\5\14\0059\5\15\0055\a\17\0009\b\r\0009\b\16\bB\b\1\2=\b\18\a9\b\r\0009\b\19\bB\b\1\2=\b\20\a9\b\r\0009\b\21\b)\nüÿB\b\2\2=\b\22\a9\b\r\0009\b\21\b)\n\4\0B\b\2\2=\b\23\a9\b\r\0009\b\24\bB\b\1\2=\b\25\a9\b\r\0009\b\26\bB\b\1\2=\b\27\a9\b\r\0009\b\28\b5\n\29\0B\b\2\2=\b\30\aB\5\2\2=\5\r\0049\5\31\0009\5 \0054\a\4\0005\b!\0>\b\1\a5\b\"\0>\b\2\a5\b#\0>\b\3\aB\5\2\2=\5 \4B\2\2\0012\0\0€K\0\1\0\1\0\1\tname\tpath\1\0\1\tname\vbuffer\1\0\1\tname\fluasnip\fsources\vconfig\t<CR>\1\0\1\vselect\1\fconfirm\n<C-e>\nabort\14<C-space>\rcomplete\n<C-f>\tC-b>\16scroll_docs\n<C-j>\21select_next_item\n<C-k>\1\0\a\t<CR>\0\14<C-space>\0\n<C-j>\0\n<C-e>\0\n<C-k>\0\n<C-f>\0\tC-b>\0\21select_prev_item\vinsert\vpreset\fmapping\fsnippet\vexpand\1\0\1\vexpand\0\0\15completion\1\0\4\fmapping\0\fsources\0\fsnippet\0\15completion\0\1\0\1\16completeopt\"menu,menuone,preview,noselect\nsetup\14lazy_load luasnip.loaders.from_vscode\fluasnip\bcmp\frequire\0" },
    loaded = true,
    path = "/Users/taylorremigi/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/Users/taylorremigi/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["oldworld.nvim"] = {
    loaded = true,
    path = "/Users/taylorremigi/.local/share/nvim/site/pack/packer/start/oldworld.nvim",
    url = "https://github.com/dgox16/oldworld.nvim"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/taylorremigi/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/taylorremigi/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/Users/taylorremigi/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22plugins.telescope\frequire\0" },
    loaded = true,
    path = "/Users/taylorremigi/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\2\n-\0\1\4\1\2\0\5-\1\0\0009\1\0\0019\3\1\0B\1\2\1K\0\1\0\1À\tbody\15lsp_expandß\5\1\0\v\0$\0F6\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0026\2\0\0'\4\3\0B\2\2\0029\2\4\2B\2\1\0019\2\5\0005\4\a\0005\5\6\0=\5\b\0045\5\n\0003\6\t\0=\6\v\5=\5\f\0049\5\r\0009\5\14\0059\5\15\0055\a\17\0009\b\r\0009\b\16\bB\b\1\2=\b\18\a9\b\r\0009\b\19\bB\b\1\2=\b\20\a9\b\r\0009\b\21\b)\nüÿB\b\2\2=\b\22\a9\b\r\0009\b\21\b)\n\4\0B\b\2\2=\b\23\a9\b\r\0009\b\24\bB\b\1\2=\b\25\a9\b\r\0009\b\26\bB\b\1\2=\b\27\a9\b\r\0009\b\28\b5\n\29\0B\b\2\2=\b\30\aB\5\2\2=\5\r\0049\5\31\0009\5 \0054\a\4\0005\b!\0>\b\1\a5\b\"\0>\b\2\a5\b#\0>\b\3\aB\5\2\2=\5 \4B\2\2\0012\0\0€K\0\1\0\1\0\1\tname\tpath\1\0\1\tname\vbuffer\1\0\1\tname\fluasnip\fsources\vconfig\t<CR>\1\0\1\vselect\1\fconfirm\n<C-e>\nabort\14<C-space>\rcomplete\n<C-f>\tC-b>\16scroll_docs\n<C-j>\21select_next_item\n<C-k>\1\0\a\t<CR>\0\14<C-space>\0\n<C-j>\0\n<C-e>\0\n<C-k>\0\n<C-f>\0\tC-b>\0\21select_prev_item\vinsert\vpreset\fmapping\fsnippet\vexpand\1\0\1\vexpand\0\0\15completion\1\0\4\fmapping\0\fsources\0\fsnippet\0\15completion\0\1\0\1\16completeopt\"menu,menuone,preview,noselect\nsetup\14lazy_load luasnip.loaders.from_vscode\fluasnip\bcmp\frequire\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22plugins.telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
