local lsp = require('mrcjk.lsp')

vim.lsp.start {
  name = 'yaml-ls',
  cmd = { 'yaml-language-server', '--stdio' },
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
  settings = {
    yaml = {
      schemas = require('schemastore').yaml.schemas(),
    },
  },
}

vim.wo[0].spell = false
