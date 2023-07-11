local files = require('mini.files')

files.setup {
  windows = {
    preview = true,
  },
}

vim.keymap.set('n', '-', function()
  files.open(vim.fn.expand('%:h'))
end, { desc = 'Open parent directory' })
