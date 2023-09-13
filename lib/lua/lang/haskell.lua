local keymap_opts = { noremap = true, silent = true }

local ok, telescope = pcall(require, 'telescope')
if ok then
  telescope.load_extension('ht')
end
vim.keymap.set('n', '<space>gp', function()
  require('haskell-tools').project.telescope_package_grep()
end, keymap_opts)
vim.keymap.set('n', '<space>gf', function()
  require('haskell-tools').project.telescope_package_files()
end, keymap_opts)
vim.keymap.set('n', '<space>gy', function()
  require('haskell-tools').project.open_package_yaml()
end, keymap_opts)
vim.keymap.set('n', '<space>gc', function()
  require('haskell-tools').project.open_package_cabal()
end, keymap_opts)
