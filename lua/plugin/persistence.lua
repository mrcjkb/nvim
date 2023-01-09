local M = {}

M.config = function()
  require('persistence').setup()
end

M.setup = function()
  local p = require('persistence')
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
end

return M
