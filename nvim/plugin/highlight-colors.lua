if vim.g.did_highlight_colors_plugin then
  return
end

vim.keymap.set('n', '<leader>ct', function()
  local hc = require('nvim-highlight-colors')
  hc.toggle()
  vim.b.highlight_colors_toggled = true
end, { noremap = true, silent = true, desc = 'highlight [c]olors: [t]oggle' })

vim.g.did_highlight_colors_plugin = true
