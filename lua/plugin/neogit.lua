local neogit = require('neogit')

neogit.setup {
  integrations = {
    diffview = true,
  },
  mappings = {
    ['a'] = 'Stage',
    ['A'] = 'StageAll',
    ['>'] = 'Toggle',
  },
}
vim.keymap.set('n', '<leader>go', neogit.open)
vim.keymap.set('n', '<leader>gs', function()
  neogit.open { kind = 'split' }
end)
