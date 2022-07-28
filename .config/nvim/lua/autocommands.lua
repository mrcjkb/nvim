
local augroup = vim.api.nvim_create_augroup('tempdir', {clear = true})
-- Do not set undofile for files in /tmp
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '/tmp/*',
  group = augroup,
  callback = function()
    vim.cmd('setlocal noundofile')
  end
})
