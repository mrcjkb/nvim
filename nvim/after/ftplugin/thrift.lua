local files = require('mrcjk.files')
files.treesitter_start()

if vim.fn.executable('thriftls') ~= 1 then
  return
end

local lsp = require('mrcjk.lsp')

---@diagnostic disable-next-line: missing-fields
vim.lsp.start {
  cmd = { 'thriftls' },
  root_dir = vim.fs.dirname(vim.fs.find({ '.git' }, { upward = true })[1]),
  filetypes = { 'thrift' },
  capabilities = lsp.capabilities,
}
