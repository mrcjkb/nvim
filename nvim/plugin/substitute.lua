local substitute = require('substitute')
substitute.setup {
  on_substitute = require('yanky.integration').substitute(),
}

vim.keymap.set('n', 's', substitute.operator, { noremap = true, desc = 'Substitute (operator)' })
vim.keymap.set('n', 'ss', substitute.line, { noremap = true, desc = 'Substitute (line)' })
vim.keymap.set('n', 'S', substitute.eol, { noremap = true, desc = 'Substitute (eol)' })
vim.keymap.set('x', 's', substitute.visual, { noremap = true, desc = 'Substitute (visual)' })
