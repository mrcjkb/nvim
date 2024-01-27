local bufnr = vim.api.nvim_get_current_buf()
if vim.b[bufnr].mrcjkb_did_ftplugin then
  return
end
vim.b[bufnr].mrcjkb_did_ftplugin = true

local lsp = require('mrcjk.lsp')

if vim.fn.executable('bash-language-server') ~= 1 then
  return
end

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
