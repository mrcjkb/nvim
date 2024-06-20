if vim.fn.executable('clangd') ~= 1 then
  return
end

require('lang.clangd').launch()
