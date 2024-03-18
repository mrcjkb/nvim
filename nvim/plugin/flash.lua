local flash = require('flash')

flash.setup {
  modes = {
    search = {
      enabled = false,
    },
    char = {
      enabled = false,
    },
  },
  search = {
    exclude = {
      'notify',
      'cmp_menu',
      'noice',
      'flash_prompt',
      'NeogitStatus',
      function(win)
        -- exclude non-focusable windows
        return not vim.api.nvim_win_get_config(win).focusable
      end,
    },
  },
  label = {
    rainbow = {
      enabled = false,
    },
  },
  prompt = {
    enabled = false,
  },
}

local function jump_to_line()
  flash.jump {
    search = { mode = 'search', max_length = 0 },
    label = { after = { 0, 0 } },
    pattern = '^',
  }
end

local function desc(description)
  return { noremap = true, silent = true, desc = description }
end
vim.keymap.set({ 'n', 'x', 'o' }, 's', flash.jump, desc('flash: jump'))
vim.keymap.set({ 'n', 'x', 'o' }, 'S', flash.treesitter, desc('flash: treesitter'))
vim.keymap.set({ 'o' }, 'r', flash.remote, desc('flash: remote'))
vim.keymap.set({ 'n', 'x', 'o' }, 'R', flash.treesitter_search, desc('flash: treesitter search'))
vim.keymap.set({ 'n', 'x', 'o' }, 'gl', jump_to_line, desc('flash: jump to [l]line'))
