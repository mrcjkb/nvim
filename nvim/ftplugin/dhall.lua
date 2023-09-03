local lsp = require('mrcjk.lsp')

vim.lsp.start {
  cmd = { 'dhall-lsp-server' },
  root_dir = vim.fs.dirname(vim.fs.find({ '.git' }, { upward = true })[1]),
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
}
