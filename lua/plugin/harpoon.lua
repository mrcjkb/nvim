local function nnoremap(keybinding, cmd)
  vim.keymap.set('n', keybinding, cmd, { noremap = true, silent = true })
end

local M = {}

function M.setup()
  nnoremap('<leader>hm', require('harpoon.mark').add_file)
  nnoremap('<leader>ht', require('harpoon.ui').toggle_quick_menu)
  nnoremap('<leader>hc', require('harpoon.cmd-ui').toggle_quick_menu)
end

require('harpoon').setup()

return M
