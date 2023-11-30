local illuminate = require('illuminate')
local files = require('mrcjk.files')
illuminate.configure {
  delay = 200,
  should_enable = function(bufnr)
    return not files.disable_treesitter_features(bufnr)
  end,
}
vim.keymap.set('n', ']]', function()
  illuminate.goto_next_reference(true)
end, { noremap = true, silent = true, desc = 'next reference' })
vim.keymap.set('n', '[[', function()
  illuminate.goto_prev_reference(true)
end, { noremap = true, silent = true, desc = 'previous reference' })
