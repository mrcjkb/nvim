if vim.g.loaded_reload_file_on_change then
  return
end
vim.g.loaded_reload_file_on_change = true

vim.api.nvim_create_autocmd({ 'VimEnter', 'FocusGained', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('ReloadFileOnChange', {}),
  command = 'checktime',
})
