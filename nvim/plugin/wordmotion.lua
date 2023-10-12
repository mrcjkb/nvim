-- Use Alt as prefix for word motion mappings
vim.g.wordmotion_mappings = {
  ['w'] = '<M-w>',
  ['b'] = '<M-b>',
  ['e'] = '<M-e>',
  ['ge'] = 'g<M-e>',
  ['aw'] = 'av',
  ['iw'] = 'iv',
  ['<C-R><C-W>'] = '<C-R><C-v>',
}
