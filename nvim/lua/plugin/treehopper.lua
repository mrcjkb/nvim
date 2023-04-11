local tsht = require('tsht')

vim.keymap.set('x', 'm', tsht.nodes, { noremap = true, silent = true })
vim.keymap.set('o', 'm', tsht.nodes, { noremap = false, silent = true })
