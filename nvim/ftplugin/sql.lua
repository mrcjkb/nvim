local lsp = require('mrcjk.lsp')

vim.lsp.start {
  cmd = { 'sqls' },
  root_dir = vim.fs.dirname(vim.fs.find({ '.git', 'config.yml' }, { upward = true })[1]),
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
  settings = {},
}
