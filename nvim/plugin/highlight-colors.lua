if vim.g.did_highlight_colors_plugin then
  return
end

local did_setup = false

vim.keymap.set('n', '<leader>ct', function()
  local hc
  if not did_setup then
    hc = require('nvim-highlight-colors')
    hc.setup {}
    hc.turnOff()
    did_setup = true
  else
    hc = require('nvim-highlight-colors')
  end
  hc.toggle()
end, { noremap = true, silent = true, desc = 'highlight [c]olors: [t]oggle' })

vim.g.did_highlight_colors_plugin = true
