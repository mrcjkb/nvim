local files = require('mrcjk.files')
files.treesitter_start()

if not vim.b.highlight_colors_toggled then
  local hc = require('nvim-highlight-colors')
  hc.turnOn()
end
