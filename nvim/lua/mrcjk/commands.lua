local api = vim.api

api.nvim_create_user_command('DeleteOtherBufs', '%bd|e#', {})
-- delete current buffer
api.nvim_create_user_command('Q', 'bd % <CR>', {})
-- delete current buffer (force) -- FIXME
-- api.nvim_create_user_command('Q!', 'bd! % <CR>', {})

-- Pandoc shortcut
api.nvim_create_user_command(
  'Pd',
  'split | resize 10 | terminal pandoc % -f markdown-implicit_figures -s -o <args>',
  { nargs = '*' }
)
