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
end, 'harpoon: [mm]ark')
nnoremap('<leader>hm', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, '[h]arpoon: toggle [m]enu')
nnoremap('[h', function()
  harpoon:list():prev()
end, '[h]arpoon: previous')
nnoremap(']h', function()
  harpoon:list():prev()
end, '[h]arpoon: next')
