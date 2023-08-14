local ssr = require('ssr')

ssr.setup()

local opts = { noremap = true, silent = true }
vim.keymap.set({ 'n', 'x' }, '<leader>sr', function()
  pcall(ssr.open)
end, opts)
