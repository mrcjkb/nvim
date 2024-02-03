require('hardtime').setup {
  max_time = 1000,
  max_count = 3,
  disable_mouse = true,
  hint = true,
  notification = true,
  allow_different_key = false,
  restricted_keys = {
    ['-'] = {}, -- Remove from default list
    ['<C-M>'] = {},
    ['<C-N>'] = {},
    ['<C-P>'] = {},
    ['<CR>'] = {},
  },
  resetting_keys = {
    ['s'] = {},
    ['S'] = {},
  },
  disabled_keys = {
    ['<CR>'] = {},
  },
  disabled_filetypes = {
    'qf',
    'netrw',
    'NeogitStatus',
    'DiffviewFilePanel',
    'query',
    'harpoon',
    'minifiles',
    'toggleterm',
    'dapui_stacks',
    'dapui_console',
    'dapui-repl',
    'dapui_watches',
    'dapui_breakpoints',
  },
}
