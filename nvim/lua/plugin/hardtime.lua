require('hardtime').setup {
  max_time = 1000,
  max_count = 3,
  disable_mouse = true,
  hint = true,
  notification = true,
  allow_different_key = false,
  disabled_filetypes = {
    'qf',
    'netrw',
    'NeogitStatus',
    'DiffviewFilePanel',
    'tsplayground',
  },
}