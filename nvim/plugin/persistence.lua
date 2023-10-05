local is_setup = false
local is_active = false

require('persistence.config').setup()

vim.api.nvim_create_autocmd('BufReadPre', {
  group = vim.api.nvim_create_augroup('persistence', { clear = true }),
  callback = function()
    if is_setup then
      return
    end
    local p = require('persistence')
    p.setup()

    vim.keymap.set('n', '<leader>ss', function()
      p.save()
      vim.notify('Saved session.', vim.log.levels.INFO)
    end, { desc = '[session] save' })

    vim.keymap.set('n', '<leader>sx', function()
      if is_active then
        p.stop()
        is_active = false
        vim.notify('Stopped session recording.', vim.log.levels.INFO)
      else
        p.start()
        is_active = true
        vim.notify('Started session recording.', vim.log.levels.INFO)
      end
    end, {})

    vim.keymap.set('n', '<leader>sx', function()
      p.stop()
      vim.notify('Stopped session recording.', vim.log.levels.INFO)
    end, { desc = '[session] stop recording' })

    is_setup = true
  end,
})

vim.keymap.set('n', '<leader>sl', function()
  require('persistence').load()
  vim.notify('Loaded session.', vim.log.levels.INFO)
end, { desc = '[session] load' })

vim.api.nvim_create_user_command('S', function()
  require('persistence').load()
end, {})
