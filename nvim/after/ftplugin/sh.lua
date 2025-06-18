local files = require('mrcjk.files')
local lsp = require('mrcjk.lsp')

files.treesitter_start('bash')

if vim.fn.executable('bash-language-server') ~= 1 then
  return
end

---@diagnostic disable-next-line: missing-fields
vim.lsp.start {
  cmd = { 'bash-language-server', 'start' },
  root_dir = vim.fs.dirname(vim.fs.find({ '.git' }, { upward = true })[1]),
  capabilities = lsp.capabilities,
  filetypes = { 'sh' },
  settings = {
    bashIde = {
      globPattern = vim.env.GLOB_PATTERN or '*@(.sh|.inc|.bash|.command)',
    },
  },
}
