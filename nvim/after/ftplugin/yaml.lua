local lsp = require('mrcjk.lsp')

local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':t')
if fname == 'package.yaml' then
  require('lang.haskell')
end

if vim.fn.executable('yaml-language-server') ~= 1 then
  return
end

---@diagnostic disable-next-line: missing-fields
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
