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
      enabled = true,
    },
  },
  prompt = {
    enabled = false,
  },
}

vim.keymap.set({ 'n', 'x', 'o' }, 's', flash.jump)
vim.keymap.set({ 'n', 'x', 'o' }, 'S', flash.treesitter)
vim.keymap.set({ 'o' }, 'r', flash.remote)
vim.keymap.set({ 'n', 'x', 'o' }, 'R', flash.treesitter_search)
