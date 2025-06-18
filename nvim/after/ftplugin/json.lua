local lsp = require('mrcjk.lsp')

local files = require('mrcjk.files')
files.treesitter_start()

if vim.fn.executable('vscode-json-languageserver') ~= 1 then
  return
end

---@diagnostic disable-next-line: missing-fields
vim.lsp.start {
  name = 'jsonls',
  cmd = { 'vscode-json-languageserver', '--stdio' },
  capabilities = lsp.capabilities,
  filetypes = { 'json' },
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
}
