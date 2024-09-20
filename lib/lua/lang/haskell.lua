local ok, telescope = pcall(require, 'telescope')
if ok then
  telescope.load_extension('ht')
end
vim.keymap.set('n', '<space>gp', function()
  require('haskell-tools').project.telescope_package_grep()
end, { noremap = true, silent = true, desc = 'haskell: telescope [g]rep [p]ackage' })
vim.keymap.set('n', '<space>gf', function()
  require('haskell-tools').project.telescope_package_files()
end, { noremap = true, silent = true, desc = 'haskell: telescope packa[g]e [f]ind files' })
vim.keymap.set('n', '<space>gy', function()
  require('haskell-tools').project.open_package_yaml()
end, { noremap = true, silent = true, desc = 'haskell: [g]o to package.[y]aml' })
vim.keymap.set('n', '<space>gc', function()
  require('haskell-tools').project.open_package_cabal()
end, { noremap = true, silent = true, desc = 'haskell: [g]o to <package>.[c]abal' })
vim.keymap.set(
  'n',
  '<space>a',
  '<Plug>HaskellHoverAction',
  { noremap = true, silent = true, desc = 'haskell: hover [a]ction' }
)
