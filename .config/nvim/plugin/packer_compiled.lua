-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

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

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/mrcjk/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?.lua;/home/mrcjk/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?/init.lua;/home/mrcjk/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?.lua;/home/mrcjk/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/mrcjk/.cache/nvim/packer_hererocks/2.0.5/lib/lua/5.1/?.so"
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
  ["autofix.nvim"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/autofix.nvim",
    url = "https://github.com/MrcJkb/autofix.nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lua"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
  },
  ["cmp-nvim-ultisnips"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/cmp-nvim-ultisnips",
    url = "https://github.com/quangnguyen30192/cmp-nvim-ultisnips"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  ["coc.nvim"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/coc.nvim",
    url = "https://github.com/neoclide/coc.nvim"
  },
  ["editorconfig-vim"] = {
    loaded = true,
    needs_bufread = false,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/opt/editorconfig-vim",
    url = "https://github.com/editorconfig/editorconfig-vim"
  },
  fzf = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/fzf",
    url = "https://github.com/junegunn/fzf"
  },
  ["fzf-hoogle.vim"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/fzf-hoogle.vim",
    url = "https://github.com/monkoose/fzf-hoogle.vim"
  },
  ["fzf.vim"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/fzf.vim",
    url = "https://github.com/junegunn/fzf.vim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\1\0026\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["glow.nvim"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/glow.nvim",
    url = "https://github.com/ellisonleao/glow.nvim"
  },
  harpoon = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/harpoon",
    url = "https://github.com/ThePrimeagen/harpoon"
  },
  indentLine = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/indentLine",
    url = "https://github.com/Yggdroot/indentLine"
  },
  ["kotlin-vim"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/kotlin-vim",
    url = "https://github.com/udalov/kotlin-vim"
  },
  ["lsp-status.nvim"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/lsp-status.nvim",
    url = "https://github.com/nvim-lua/lsp-status.nvim"
  },
  ["lsp_signature.nvim"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/lsp_signature.nvim",
    url = "https://github.com/ray-x/lsp_signature.nvim"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/lspkind-nvim",
    url = "https://github.com/onsails/lspkind-nvim"
  },
  ["lua-dev.nvim"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/lua-dev.nvim",
    url = "https://github.com/folke/lua-dev.nvim"
  },
  ["lualine.nvim"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/hoob3rt/lualine.nvim"
  },
  ["markdown-preview.nvim"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/markdown-preview.nvim",
    url = "https://github.com/iamcco/markdown-preview.nvim"
  },
  ["material.vim"] = {
    loaded = true,
    needs_bufread = false,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/opt/material.vim",
    url = "https://github.com/kaicataldo/material.vim"
  },
  ["nlua.nvim"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/nlua.nvim",
    url = "https://github.com/tjdevries/nlua.nvim"
  },
  ["nvim-autopairs"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/nvim-autopairs",
    url = "https://github.com/windwp/nvim-autopairs"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-colorizer.lua"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua",
    url = "https://github.com/norcalli/nvim-colorizer.lua"
  },
  ["nvim-dap"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/nvim-dap",
    url = "https://github.com/mfussenegger/nvim-dap"
  },
  ["nvim-dap-python"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/nvim-dap-python",
    url = "https://github.com/mfussenegger/nvim-dap-python"
  },
  ["nvim-dap-ui"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/nvim-dap-ui",
    url = "https://github.com/rcarriga/nvim-dap-ui"
  },
  ["nvim-dap-virtual-text"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/nvim-dap-virtual-text",
    url = "https://github.com/theHamsta/nvim-dap-virtual-text"
  },
  ["nvim-gps"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/nvim-gps",
    url = "https://github.com/SmiteshP/nvim-gps"
  },
  ["nvim-java-tsls"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/nvim-java-tsls",
    url = "https://github.com/MrcJkb/nvim-java-tsls"
  },
  ["nvim-jdtls"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/nvim-jdtls",
    url = "https://github.com/mfussenegger/nvim-jdtls"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-lsputils"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/nvim-lsputils",
    url = "https://github.com/RishabhRD/nvim-lsputils"
  },
  ["nvim-luadev"] = {
    commands = { "Luadev" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/opt/nvim-luadev",
    url = "https://github.com/bfredl/nvim-luadev"
  },
  ["nvim-metals"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/nvim-metals",
    url = "https://github.com/scalameta/nvim-metals"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\1\2•\1\0\0\3\0\b\0\v4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\4\0003\2\3\0:\2\5\0013\2\6\0:\2\a\1>\0\2\1G\0\1\0\frainbow\1\0\3\19max_file_lines\3Ë\a\18extended_mode\2\venable\2\14highlight\1\0\0\1\0\1\venable\2\nsetup\28nvim-treesitter.configs\frequire\0" },
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects"
  },
  ["nvim-ts-rainbow"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/nvim-ts-rainbow",
    url = "https://github.com/p00f/nvim-ts-rainbow"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["one-small-step-for-vimkind"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/one-small-step-for-vimkind",
    url = "https://github.com/jbyuki/one-small-step-for-vimkind"
  },
  ["open-browser.vim"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/open-browser.vim",
    url = "https://github.com/tyru/open-browser.vim"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plantuml-previewer.vim"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/plantuml-previewer.vim",
    url = "https://github.com/weirongxu/plantuml-previewer.vim"
  },
  ["plantuml-syntax"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/plantuml-syntax",
    url = "https://github.com/aklt/plantuml-syntax"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  popfix = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/popfix",
    url = "https://github.com/RishabhRD/popfix"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/popup.nvim",
    url = "https://github.com/nvim-lua/popup.nvim"
  },
  ["quick-scope"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/quick-scope",
    url = "https://github.com/unblevable/quick-scope"
  },
  rnvimr = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/rnvimr",
    url = "https://github.com/kevinhwang91/rnvimr"
  },
  ["rust-tools.nvim"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/rust-tools.nvim",
    url = "https://github.com/simrat39/rust-tools.nvim"
  },
  ["snippets.nvim"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/snippets.nvim",
    url = "https://github.com/norcalli/snippets.nvim"
  },
  ["telescope-fzy-native.nvim"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/telescope-fzy-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzy-native.nvim"
  },
  ["telescope-ultisnips.nvim"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/telescope-ultisnips.nvim",
    url = "https://github.com/fhill2/telescope-ultisnips.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  telescope_hoogle = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/telescope_hoogle",
    url = "https://github.com/luc-tielen/telescope_hoogle"
  },
  ["toggleterm.nvim"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/toggleterm.nvim",
    url = "https://github.com/akinsho/toggleterm.nvim"
  },
  ["twilight.nvim"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/twilight.nvim",
    url = "https://github.com/folke/twilight.nvim"
  },
  ultisnips = {
    after_files = { "/home/mrcjk/.local/share/nvim/site/pack/packer/opt/ultisnips/after/plugin/UltiSnips_after.vim" },
    loaded = true,
    needs_bufread = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/opt/ultisnips",
    url = "https://github.com/SirVer/ultisnips"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/vim-commentary",
    url = "https://github.com/tpope/vim-commentary"
  },
  ["vim-devicons"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/vim-devicons",
    url = "https://github.com/ryanoasis/vim-devicons"
  },
  ["vim-dispatch"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/vim-dispatch",
    url = "https://github.com/tpope/vim-dispatch"
  },
  ["vim-easy-align"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/vim-easy-align",
    url = "https://github.com/junegunn/vim-easy-align"
  },
  ["vim-fubitive"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/vim-fubitive",
    url = "https://github.com/tommcdo/vim-fubitive"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-javascript"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/vim-javascript",
    url = "https://github.com/pangloss/vim-javascript"
  },
  ["vim-obsession"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/vim-obsession",
    url = "https://github.com/tpope/vim-obsession"
  },
  ["vim-polyglot"] = {
    loaded = true,
    needs_bufread = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/opt/vim-polyglot",
    url = "https://github.com/sheerun/vim-polyglot"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  ["vim-rhubarb"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/vim-rhubarb",
    url = "https://github.com/tpope/vim-rhubarb"
  },
  ["vim-sneak"] = {
    loaded = true,
    needs_bufread = false,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/opt/vim-sneak",
    url = "https://github.com/justinmk/vim-sneak"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/vim-surround",
    url = "https://github.com/tpope/vim-surround"
  },
  ["vim-system-copy"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/vim-system-copy",
    url = "https://github.com/christoomey/vim-system-copy"
  },
  ["vim-table-mode"] = {
    loaded = true,
    needs_bufread = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/opt/vim-table-mode",
    url = "https://github.com/dhruvasagar/vim-table-mode"
  },
  ["vim-test"] = {
    loaded = true,
    needs_bufread = false,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/opt/vim-test",
    url = "https://github.com/vim-test/vim-test"
  },
  ["vim-textobj-user"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/vim-textobj-user",
    url = "https://github.com/kana/vim-textobj-user"
  },
  ["vim-unimpaired"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/vim-unimpaired",
    url = "https://github.com/tpope/vim-unimpaired"
  },
  ["vim-vsnip"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/vim-vsnip",
    url = "https://github.com/hrsh7th/vim-vsnip"
  },
  ["vim-vsnip-integ"] = {
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/vim-vsnip-integ",
    url = "https://github.com/hrsh7th/vim-vsnip-integ"
  },
  ["vim-wordmotion"] = {
    loaded = true,
    needs_bufread = false,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/opt/vim-wordmotion",
    url = "https://github.com/chaoren/vim-wordmotion"
  },
  ["zen-mode.nvim"] = {
    config = { "\27LJ\1\2≠\1\0\0\5\0\v\0\0154\0\0\0007\0\1\0007\0\2\0%\1\3\0%\2\4\0%\3\5\0003\4\6\0>\0\5\0014\0\a\0%\1\b\0>\0\2\0027\0\t\0003\1\n\0>\0\2\1G\0\1\0\1\0\1\rbackdrop\3\1\nsetup\rzen-mode\frequire\1\0\2\vsilent\2\fnoremap\2\17:ZenMode<Cr>\14<leader>z\6n\20nvim_set_keymap\bapi\bvim\0" },
    loaded = true,
    path = "/home/mrcjk/.local/share/nvim/site/pack/packer/start/zen-mode.nvim",
    url = "https://github.com/folke/zen-mode.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Setup for: material.vim
time([[Setup for material.vim]], true)
try_loadstring("\27LJ\1\2ê\1\0\0\2\0\a\0\r4\0\0\0007\0\1\0%\1\3\0:\1\2\0004\0\0\0007\0\1\0'\1\1\0:\1\4\0004\0\0\0007\0\5\0%\1\6\0>\0\2\1G\0\1\0\25colorscheme material\bcmd\30material_terminal_italics\vdarker\25material_theme_style\6g\bvim\0", "setup", "material.vim")
time([[Setup for material.vim]], false)
time([[packadd for material.vim]], true)
vim.cmd [[packadd material.vim]]
time([[packadd for material.vim]], false)
-- Setup for: vim-test
time([[Setup for vim-test]], true)
try_loadstring("\27LJ\1\2b\0\0\2\0\6\0\t4\0\0\0007\0\1\0%\1\3\0:\1\2\0004\0\0\0007\0\1\0%\1\5\0:\1\4\0G\0\1\0\15gradletest\21test#java#runner\vneovim\18test#strategy\6g\bvim\0", "setup", "vim-test")
time([[Setup for vim-test]], false)
time([[packadd for vim-test]], true)
vim.cmd [[packadd vim-test]]
time([[packadd for vim-test]], false)
-- Setup for: editorconfig-vim
time([[Setup for editorconfig-vim]], true)
try_loadstring('\27LJ\1\2Q\0\0\2\0\4\0\0054\0\0\0007\0\1\0003\1\3\0:\1\2\0G\0\1\0\1\2\0\0\18fugitive://.*"EditorConfig_exclude_patterns\6g\bvim\0', "setup", "editorconfig-vim")
time([[Setup for editorconfig-vim]], false)
time([[packadd for editorconfig-vim]], true)
vim.cmd [[packadd editorconfig-vim]]
time([[packadd for editorconfig-vim]], false)
-- Setup for: vim-wordmotion
time([[Setup for vim-wordmotion]], true)
try_loadstring("\27LJ\1\2;\0\0\2\0\4\0\0054\0\0\0007\0\1\0%\1\3\0:\1\2\0G\0\1\0\f<Space>\22wordmotion_prefix\6g\bvim\0", "setup", "vim-wordmotion")
time([[Setup for vim-wordmotion]], false)
time([[packadd for vim-wordmotion]], true)
vim.cmd [[packadd vim-wordmotion]]
time([[packadd for vim-wordmotion]], false)
-- Setup for: vim-sneak
time([[Setup for vim-sneak]], true)
try_loadstring("\27LJ\1\2®\1\0\0\2\0\a\0\r4\0\0\0007\0\1\0'\1\1\0:\1\2\0004\0\0\0007\0\1\0%\1\4\0:\1\3\0004\0\0\0007\0\5\0%\1\6\0>\0\2\1G\0\1\0I      map <M-f> <Plug>Sneak_s\n      map map <M-F> <Plug>Sneak_S\n    \bcmd\tüîç\17sneak#prompt\16sneak#label\6g\bvim\0", "setup", "vim-sneak")
time([[Setup for vim-sneak]], false)
time([[packadd for vim-sneak]], true)
vim.cmd [[packadd vim-sneak]]
time([[packadd for vim-sneak]], false)
-- Setup for: vim-table-mode
time([[Setup for vim-table-mode]], true)
try_loadstring("\27LJ\1\2ã\1\0\0\2\0\a\0\r4\0\0\0007\0\1\0%\1\3\0:\1\2\0004\0\0\0007\0\1\0%\1\3\0:\1\4\0004\0\0\0007\0\1\0%\1\6\0:\1\5\0G\0\1\0\6=\31table_mode_header_fillchar\29table_mode_corner_corner\6+\22table_mode_corner\6g\bvim\0", "setup", "vim-table-mode")
time([[Setup for vim-table-mode]], false)
time([[packadd for vim-table-mode]], true)
vim.cmd [[packadd vim-table-mode]]
time([[packadd for vim-table-mode]], false)
-- Setup for: ultisnips
time([[Setup for ultisnips]], true)
try_loadstring("\27LJ\1\2U\0\0\2\0\4\0\0054\0\0\0007\0\1\0003\1\3\0:\1\2\0G\0\1\0\1\3\0\0\14UltiSnips\14ultisnips UltiSnipsSnippetDirectories\6g\bvim\0", "setup", "ultisnips")
time([[Setup for ultisnips]], false)
time([[packadd for ultisnips]], true)
vim.cmd [[packadd ultisnips]]
time([[packadd for ultisnips]], false)
-- Setup for: vim-polyglot
time([[Setup for vim-polyglot]], true)
try_loadstring("\27LJ\1\2<\0\0\2\0\4\0\0054\0\0\0007\0\1\0003\1\3\0:\1\2\0G\0\1\0\1\2\0\0\tjava\22polyglot_disabled\6g\bvim\0", "setup", "vim-polyglot")
time([[Setup for vim-polyglot]], false)
time([[packadd for vim-polyglot]], true)
vim.cmd [[packadd vim-polyglot]]
time([[packadd for vim-polyglot]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\1\2•\1\0\0\3\0\b\0\v4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\4\0003\2\3\0:\2\5\0013\2\6\0:\2\a\1>\0\2\1G\0\1\0\frainbow\1\0\3\19max_file_lines\3Ë\a\18extended_mode\2\venable\2\14highlight\1\0\0\1\0\1\venable\2\nsetup\28nvim-treesitter.configs\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: zen-mode.nvim
time([[Config for zen-mode.nvim]], true)
try_loadstring("\27LJ\1\2≠\1\0\0\5\0\v\0\0154\0\0\0007\0\1\0007\0\2\0%\1\3\0%\2\4\0%\3\5\0003\4\6\0>\0\5\0014\0\a\0%\1\b\0>\0\2\0027\0\t\0003\1\n\0>\0\2\1G\0\1\0\1\0\1\rbackdrop\3\1\nsetup\rzen-mode\frequire\1\0\2\vsilent\2\fnoremap\2\17:ZenMode<Cr>\14<leader>z\6n\20nvim_set_keymap\bapi\bvim\0", "config", "zen-mode.nvim")
time([[Config for zen-mode.nvim]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\1\0026\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Luadev lua require("packer.load")({'nvim-luadev'}, { cmd = "Luadev", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
