local bufnr = vim.api.nvim_get_current_buf()
if vim.b[bufnr].mrcjkb_did_ftplugin then
  return
end
vim.b[bufnr].mrcjkb_did_ftplugin = true

local lsp = require('mrcjk.lsp')

if vim.fn.executable('json-languageserver') ~= 1 then
  return
end

vim.lsp.start {
  name = 'jsonls',
  cmd = { 'json-languageserver', '--stdio' },
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
  settings = {
    yaml = {
      schemas = require('schemastore').yaml.schemas(),
    },
  },
}
