-- Use Alt as prefix for word motion mappings
vim.g.wordmotion_mappings = {
  ['w'] = '<M-w>',
  ['b'] = '<M-b>',
  ['e'] = '<M-e>',
  ['ge'] = 'g<M-e>',
  ['aw'] = 'a<M-w>',
  ['iw'] = 'i<M-w>',
  ['<C-R><C-W>'] = '<C-R><M-w>',
}
