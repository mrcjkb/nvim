-- Do not set undofile for files in /tmp
if vim.g.loaded_noundofile_tmp then
  return
end
vim.g.loaded_noundofile_tmp = true

local api = vim.api

api.nvim_create_autocmd('BufWritePre', {
  pattern = '/tmp/*',
  group = api.nvim_create_augroup('noundofile-tmp', { clear = true }),
  callback = function()
    vim.cmd.setlocal('noundofile')
  end,
})
