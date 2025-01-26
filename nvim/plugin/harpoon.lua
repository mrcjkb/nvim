local keymap = require('lz.n').keymap {
  'harpoon',
  keys = '<leader>tm',
  after = function()
    require('harpoon'):setup {
      settings = {
        save_on_toggle = true,
      },
    }
  end,
}

---@param keybinding string
---@param cmd function | string
---@param description string
local function nnoremap(keybinding, cmd, description)
  keymap.set('n', keybinding, cmd, { noremap = true, silent = true, desc = description })
end

nnoremap('<leader>mm', function()
  require('harpoon'):list():append()
end, 'harpoon: [mm]ark')
nnoremap('<leader>hm', function()
  local harpoon = require('harpoon')
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, '[h]arpoon: toggle [m]enu')
nnoremap('[h', function()
  require('harpoon'):list():prev()
end, '[h]arpoon: previous')
nnoremap(']h', function()
  require('harpoon'):list():prev()
end, '[h]arpoon: next')
