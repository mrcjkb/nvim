require('gitlinker').setup {
  callbacks = {
    ['gitlab.internal.tiko.ch'] = require('gitlinker.hosts').get_gitlab_type_url,
  },
}

vim.keymap.set('n', '<leader>gB', function()
  require('gitlinker').get_repo_url { action_callback = require('gitlinker.actions').open_in_browser }
end, { silent = true })
