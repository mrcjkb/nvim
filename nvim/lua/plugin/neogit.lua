local neogit = require('neogit')

neogit.setup {
  integrations = {
    diffview = true,
  },
  sections = {
    recent = {
      folded = false,
    },
  },
}
vim.keymap.set('n', '<leader>go', neogit.open)
vim.keymap.set('n', '<leader>gs', function()
  neogit.open { kind = 'split' }
end)
