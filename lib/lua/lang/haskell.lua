pcall(function()
  require('lz.n').trigger_load('telescope.nvim')
  require('telescope').load_extension('ht')
end)

local M = {}

function M.set_keymaps()
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
end

return M
