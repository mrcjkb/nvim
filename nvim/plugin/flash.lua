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

local function desc(description)
  return { noremap = true, silent = true, desc = description }
end
vim.keymap.set({ 'n', 'x', 'o' }, '<leader><leader>', flash.jump, desc('flash: jump'))
vim.keymap.set({ 'o' }, 'r', flash.remote, desc('flash: remote'))
