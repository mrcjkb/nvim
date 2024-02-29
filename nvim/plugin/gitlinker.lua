local gitlinker = require('gitlinker')
gitlinker.setup {
  callbacks = {
    ['gitlab.internal.tiko.ch'] = require('gitlinker.hosts').get_gitlab_type_url,
  },
}

local actions = require('gitlinker.actions')

vim.keymap.set('n', '<leader>gb', function()
  gitlinker.get_buf_range_url('n', { action_callback = actions.open_in_browser })
end, { silent = true, desc = '[g]it: open [b]uffer url in browser' })

vim.keymap.set('v', '<leader>gb', function()
  gitlinker.get_buf_range_url('v', { action_callback = actions.open_in_browser })
end, { silent = true, desc = '[g]it: open in [b]rowser' })

vim.keymap.set('n', '<leader>gB', function()
  gitlinker.get_repo_url { action_callback = actions.open_in_browser }
end, { silent = true, desc = '[g]it: open repo in [B]rowser' })
