local lsp = require('mrcjk.lsp')
local files = require('mrcjk.files')

files.treesitter_start()

if vim.fn.executable('dhall-lsp-server') ~= 1 then
  return
end

---@diagnostic disable-next-line: missing-fields
vim.lsp.start {
  cmd = { 'dhall-lsp-server' },
  root_dir = vim.fs.dirname(vim.fs.find({ '.git' }, { upward = true })[1]),
  filetypes = { 'dhall' },
  capabilities = lsp.capabilities,
}
