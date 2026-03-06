local files = require('mrcjk.files')
files.treesitter_start()

if vim.fn.executable('graphql-lsp') ~= 1 then
  return
end

vim.print('graphql')

vim.lsp.start {
  cmd = { 'graphql-lsp', 'server', '-m', 'stream' },
  root_dir = vim.fs.dirname(
    vim.fs.find({ '.graphqlrc*', '.graphql.config.*', 'graphql.config.*', '.git' }, { upward = true })[1]
  ),
}
