local api = vim.api

local tempdirgroup = api.nvim_create_augroup('tempdir', {clear = true})
-- Do not set undofile for files in /tmp
api.nvim_create_autocmd('BufWritePre', {
  pattern = '/tmp/*',
  group = tempdirgroup,
  callback = function()
    vim.cmd('setlocal noundofile')
  end
})

