require('todo-comments').setup {
  highlight = {
    pattern = {
      [[.*<(KEYWORDS)\s*:]],
      [[.*<(KEYWORDS)\s*]],
      [[.*<(KEYWORDS)\(.*\)\s*:]],
    },
  },
}

vim.keymap.set('n', ']t', function()
  require('todo-comments').jump_next { keywords = { 'TODO' } }
end, { desc = 'Next [t]odo comment' })

vim.keymap.set('n', '[t', function()
  require('todo-comments').jump_prev { keywords = { 'TODO' } }
end, { desc = 'Previous [t]odo comment' })
