local bufnr = vim.api.nvim_get_current_buf()
if vim.b[bufnr].mrcjkb_did_ftplugin then
  return
end
vim.b[bufnr].mrcjkb_did_ftplugin = true

local lsp = require('mrcjk.lsp')

if vim.fn.executable('vimls') ~= 1 then
  return
end

vim.lsp.start {
  name = 'vimls',
  cmd = { 'vim-language-server', '--stdio' },
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
  init_options = {
    isNeovim = true,
    iskeyword = '@,48-57,_,192-255,-#',
    vimruntime = '',
    runtimepath = '',
    diagnostic = { enable = true },
    indexes = {
      runtimepath = true,
      gap = 100,
      count = 3,
      projectRootPatterns = { 'runtime', 'nvim', '.git', 'autoload', 'plugin' },
    },
    suggest = { fromVimruntime = true, fromRuntimepath = true },
  },
}
