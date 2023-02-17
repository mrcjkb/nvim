local lspconfig = require('lspconfig')
local lsp = require('mrcjk.lsp')

-- C/C++ -- TODO: Complete
lspconfig.clangd.setup {
  autostart = false,
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
}

return lspconfig.clangd
