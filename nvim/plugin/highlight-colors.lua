require('nvim-highlight-colors').setup {
  -- render = 'virtual',
}
vim.cmd.HighlightColors('off')

vim.keymap.set('n', '<leader>ct', function()
  vim.cmd.HighlightColors('toggle')
end, { noremap = true, silent = true, desc = 'highlight [c]olors: [t]oggle' })
