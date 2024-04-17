local substitute = require('substitute')
substitute.setup {
  on_substitute = require('yanky.integration').substitute(),
}

vim.keymap.set('n', '<leader><leader>s', substitute.operator, { noremap = true })
vim.keymap.set('n', '<leader><leader>ss', substitute.line, { noremap = true })
vim.keymap.set('n', '<leader><leader>S', substitute.eol, { noremap = true })
vim.keymap.set('x', '<leader><leader>s', substitute.visual, { noremap = true })
