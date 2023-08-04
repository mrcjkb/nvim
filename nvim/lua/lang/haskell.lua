local ht = require('haskell-tools')
local keymap_opts = { noremap = true, silent = true }

vim.keymap.set('n', '<space>gp', ht.project.telescope_package_grep, keymap_opts)
vim.keymap.set('n', '<space>gf', ht.project.telescope_package_files, keymap_opts)
vim.keymap.set('n', '<space>gp', ht.project.telescope_package_grep, keymap_opts)
vim.keymap.set('n', '<space>gf', ht.project.telescope_package_files, keymap_opts)

if ht.dap then
  local bufnr = vim.api.nvim_get_current_buf()
  ht.dap.discover_configurations(bufnr)
end
