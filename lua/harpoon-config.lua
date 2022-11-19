local function nnoremap(keybinding, cmd)
  vim.api.nvim_set_keymap('n', keybinding, cmd, { noremap = true, silent = true })
end

local M = {}

function M.setup()
  nnoremap('<leader>hm', "<Cmd>lua require('harpoon.mark').add_file()<CR>")
  nnoremap('<leader>ht', "<Cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>")
  nnoremap('<leader>hc', "<Cmd>lua require('harpoon.cmd-ui').toggle_quick_menu()<CR>")
end

require('harpoon').setup()

return M
