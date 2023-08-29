local illuminate = require('illuminate')
illuminate.configure {
  delay = 200,
}
local opts = { noremap = true, silent = true }
vim.keymap.set('n', ']]', function()
  illuminate.goto_next_reference(true)
end, opts)
vim.keymap.set('n', '[[', function()
  illuminate.goto_prev_reference(true)
end, opts)
