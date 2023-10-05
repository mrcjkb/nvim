local illuminate = require('illuminate')
illuminate.configure {
  delay = 200,
}
vim.keymap.set('n', ']]', function()
  illuminate.goto_next_reference(true)
end, { noremap = true, silent = true, desc = 'next reference' })
vim.keymap.set('n', '[[', function()
  illuminate.goto_prev_reference(true)
end, { noremap = true, silent = true, desc = 'previous reference' })
