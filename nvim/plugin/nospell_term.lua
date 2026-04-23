-- Set nospell in terminal
if vim.g.loaded_nospell_term then
  return
end
vim.g.loaded_nospell_term = true

vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('nospell', { clear = true }),
  callback = function()
    vim.wo[0].spell = false
  end,
})
