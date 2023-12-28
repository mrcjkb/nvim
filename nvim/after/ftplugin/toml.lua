local lsp = require('mrcjk.lsp')

if vim.fn.executable('taplo') ~= 1 then
  return
end

vim.lsp.start {
  name = 'taplo',
  cmd = { 'taplo', 'lsp', 'stdio' },
  capabilities = lsp.capabilities,
  on_attach = lsp.on_attach,
  init_options = {
    configurationSection = 'evenBetterToml',
    cachePath = vim.NIL,
  },
  root_dir = vim.fs.dirname(vim.fs.find({ 'taplo.toml', '.taplo.toml' }, { upward = true })[1]),
}
