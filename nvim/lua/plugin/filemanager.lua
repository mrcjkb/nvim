require('mini.files').setup {
  windows = {
    preview = true,
  },
}

vim.keymap.set('n', '-', function()
  MiniFiles.open(vim.fn.expand('%:h'))
end, { desc = 'Open parent directory' })
