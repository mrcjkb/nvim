local files = require('mrcjk.files')
files.treesitter_start()

local lsp = require('mrcjk.lsp')

if vim.fn.executable('sqls') ~= 1 then
  return
end

---@diagnostic disable-next-line: missing-fields
vim.lsp.start {
  cmd = { 'sqls' },
  root_dir = vim.fs.dirname(vim.fs.find({ '.git', 'config.yml' }, { upward = true })[1]),
  capabilities = lsp.capabilities,
  settings = {},
}
