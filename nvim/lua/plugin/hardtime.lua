require('hardtime').setup {
  max_time = 1000,
  max_count = 3,
  disable_mouse = true,
  hint = true,
  notification = true,
  allow_different_key = false,
  restricted_keys = {
    ['-'] = {}, -- Remove from default list
    ['<C-P>'] = {},
    ['<CR>'] = {},
  },
  disabled_keys = {
    ['<CR>'] = {},
  },
  disabled_filetypes = {
    'qf',
    'netrw',
    'NeogitStatus',
    'DiffviewFilePanel',
    'tsplayground',
    'harpoon',
    'toggleterm',
    'dapui_stacks',
    'dapui_console',
    'dapui-repl',
    'dapui_watches',
    'dapui_breakpoints',
  },
}
