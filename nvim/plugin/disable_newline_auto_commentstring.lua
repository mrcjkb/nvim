if vim.g.loaded_disable_newline_auto_commentstring then
  return
end
vim.g.loaded_disable_newline_auto_commentstring = true

vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('DisableNewLineAutoCommentString', {}),
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions - { 'c', 'r', 'o' }
  end,
})
