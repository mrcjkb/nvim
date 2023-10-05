local files = require('mini.files')

files.setup {
  windows = {
    preview = true,
  },
}

vim.keymap.set('n', '-', function()
  local path = vim.fn.expand('%:h') or vim.fn.getcwd()
  return type(path) == 'string' and files.open(path)
end, { desc = 'open parent directory' })
