local lsp = require('mrcjk.lsp')

vim.lsp.start {
  cmd = { 'bash-language-server', 'start' },
  root_dir = vim.fs.dirname(vim.fs.find({ '.git' }, { upward = true })[1]),
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
  settings = {
    bashIde = {
      globPattern = vim.env.GLOB_PATTERN or '*@(.sh|.inc|.bash|.command)',
    },
  },
}
