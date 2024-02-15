local bufnr = vim.api.nvim_get_current_buf()
if vim.b[bufnr].mrcjkb_did_ftplugin then
  return
end

if vim.fn.executable('clangd') ~= 1 then
  return
end

vim.b[bufnr].mrcjkb_did_ftplugin = true

require('lang.clangd').launch()
