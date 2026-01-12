local files = require('mrcjk.files')
files.treesitter_start()

if vim.bo[0].buftype == 'nofile' then
  return
end

local lsp = require('mrcjk.lsp')

local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':t')
if fname == 'package.yaml' then
  require('lang.haskell').set_keymaps()
end

if vim.fn.executable('yaml-language-server') ~= 1 then
  return
end

---@diagnostic disable-next-line: missing-fields
vim.lsp.start {
  name = 'yaml-ls',
  cmd = { 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml' },
  capabilities = lsp.capabilities,
  settings = {
    yaml = {
      schemaStore = {
        -- Disable built-in schemaStore support to use
        -- schemastore.nvim and its advanced options like `ignore`.
        enable = false,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = '',
      },
      schemas = require('schemastore').yaml.schemas(),
    },
  },
}

vim.wo[0].spell = false
