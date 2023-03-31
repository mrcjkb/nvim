local femaco = require('femaco')

femaco.setup()

vim.keymap.set('n', '<leader>fe', femaco.edit_code_block, { noremap = true, silent = true })
