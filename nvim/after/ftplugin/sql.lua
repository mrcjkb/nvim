local files = require('mrcjk.files')
files.treesitter_start()

if vim.bo[0].buftype == 'nofile' then
  return
end

local lsp = require('mrcjk.lsp')

if vim.fn.executable('sqls') ~= 1 then
  return
end

---@diagnostic disable-next-line: missing-fields
vim.lsp.start {
  cmd = { 'sqls' },
  root_dir = vim.fs.dirname(vim.fs.find({ '.git', 'config.yml' }, { upward = true })[1]),
  filetypes = { 'sql' },
  capabilities = lsp.capabilities,
  settings = {},
}
