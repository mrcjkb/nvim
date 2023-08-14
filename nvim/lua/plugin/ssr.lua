local ssr = require('ssr')
ssr.setup()
vim.keymap.set({ 'n', 'x' }, '<leader>sr', ssr.open)
