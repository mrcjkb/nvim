local oil = require('oil')

oil.setup {
  view_options = {
    -- Show files and directories that start with "."
    show_hidden = true,
  },
}

vim.keymap.set('n', '-', function()
  vim.cmd.Oil()
end, { desc = 'open parent directory' })
