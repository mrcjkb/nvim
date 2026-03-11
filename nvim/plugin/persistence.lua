local is_setup = false
local is_active = false

require('persistence.config').setup()

vim.api.nvim_create_user_command('S', function()
  require('persistence').load()
end, {
  desc = 'Load session',
})

vim.api.nvim_create_user_command('Restart', function()
  require('persistence').save()
  vim.notify('Saved session. Restarting...', vim.log.levels.INFO)
  vim.cmd.restart('S')
end, {
  desc = 'Restart and reload current session',
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('persistence', { clear = true }),
  once = true,
  pattern = '*',
  callback = function()
    if is_setup then
      return
    end
    local p = require('persistence')
    p.setup()

    vim.keymap.set('n', '<leader>ss', function()
      p.save()
      vim.notify('Saved session.', vim.log.levels.INFO)
    end, { desc = '[s]ession: [s]ave' })

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
    end, { desc = 'start/stop recording [s]ession [x]' })

    vim.keymap.set('n', '<leader>sr', vim.cmd.Restart, { desc = '[s]ession: [r]estart' })

    is_setup = true
  end,
})

vim.keymap.set('n', '<leader>sl', function()
  require('persistence').load()
  vim.notify('Loaded session.', vim.log.levels.INFO)
end, { desc = '[s]ession: [l]oad' })
