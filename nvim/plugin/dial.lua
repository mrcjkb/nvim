require('lz.n').load {
  'dial.nvim',
  ---@type lz.n.KeysSpec[]
  keys = {
    { '<C-a>', '<Plug>(dial-increment)', mode = { 'n', 'v' } },
    { '<C-x>', '<Plug>(dial-decrement)', mode = { 'n', 'v' } },
    { 'g<C-a>', 'g<Plug>(dial-increment)', mode = { 'n', 'v' } },
    { 'g<C-x>', 'g<Plug>(dial-decrement)', mode = { 'n', 'v' } },
  },
}
