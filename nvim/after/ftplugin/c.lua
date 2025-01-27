local files = require('mrcjk.files')
files.treesitter_start()

if vim.fn.executable('clangd') ~= 1 then
  return
end

require('lang.clangd').launch()
