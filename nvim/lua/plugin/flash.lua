local flash = require('flash')

flash.setup {}

vim.keymap.set({ 'n', 'x', 'o' }, 's', flash.jump)
vim.keymap.set({ 'n', 'x', 'o' }, 'S', flash.treesitter)
vim.keymap.set({ 'o' }, 'r', flash.remote)
vim.keymap.set({ 'n', 'x', 'o' }, 'R', flash.treesitter_search)
