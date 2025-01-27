local lsp = require('mrcjk.lsp')

local files = require('mrcjk.files')
files.treesitter_start()

if vim.fn.executable('json-languageserver') ~= 1 then
  return
end

---@diagnostic disable-next-line: missing-fields
vim.lsp.start {
  name = 'jsonls',
  cmd = { 'json-languageserver', '--stdio' },
  capabilities = lsp.capabilities,
  settings = {
    yaml = {
      schemas = require('schemastore').yaml.schemas(),
    },
  },
}
