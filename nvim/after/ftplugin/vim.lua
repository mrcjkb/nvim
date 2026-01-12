local files = require('mrcjk.files')
files.treesitter_start()

if vim.bo[0].buftype == 'nofile' then
  return
end

local lsp = require('mrcjk.lsp')

if vim.fn.executable('vimls') ~= 1 then
  return
end

vim.lsp.start {
  name = 'vimls',
  cmd = { 'vim-language-server', '--stdio' },
  filetypes = { 'vim' },
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
