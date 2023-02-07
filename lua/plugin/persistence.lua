local p = require('persistence')

p.setup()

vim.keymap.set('n', '<leader>ss', function()
  p.save()
  print('Saved session.')
end, {})

vim.keymap.set('n', '<leader>sl', function()
  p.load()
  print('Loaded session.')
end, {})

vim.keymap.set('n', '<leader>sx', function()
  p.stop()
  print('Stopped session recording.')
end, {})
