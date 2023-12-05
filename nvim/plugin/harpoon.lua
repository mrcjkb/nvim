local harpoon = require('harpoon')

harpoon:setup {
  settings = {
    save_on_toggle = true,
  },
}

---@param keybinding string
---@param cmd function | string
---@param description string
local function nnoremap(keybinding, cmd, description)
  vim.keymap.set('n', keybinding, cmd, { noremap = true, silent = true, desc = description })
end

nnoremap('<leader>mm', function()
  harpoon:list():append()
end, '[harpoon] mark')
nnoremap('<leader>hm', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, '[harpoon] toggle menu')
nnoremap('[h', function()
  harpoon:list():prev()
end, '[harpoon] previous')
nnoremap(']h', function()
  harpoon:list():prev()
end, '[harpoon] next')
