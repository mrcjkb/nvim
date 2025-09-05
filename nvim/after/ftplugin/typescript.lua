local files = require('mrcjk.files')
files.treesitter_start()

local lsp = require('mrcjk.lsp')

if vim.fn.executable('typescript-language-server') ~= 1 then
  return
end

local root_files = {
  'package.json',
  '.git',
}

vim.lsp.start {
  name = 'tsls',
  cmd = { 'typescript-language-server', '--stdio' },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  filetypes = { 'typescript' },
  capabilities = lsp.capabilities,
}
