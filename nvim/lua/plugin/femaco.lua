require('femaco').setup()

vim.keymap.set('n', '<leader>fe', function()
  require('femaco.edit').edit_code_block()
end, { noremap = true, silent = true })
