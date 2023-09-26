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

local function jump_to_line()
  flash.jump {
    search = { mode = 'search', max_length = 0 },
    label = { after = { 0, 0 } },
    pattern = '^',
  }
end

local keymap_opts = { noremap = true, silent = true }
vim.keymap.set({ 'n', 'x', 'o' }, 's', flash.jump, keymap_opts)
vim.keymap.set({ 'n', 'x', 'o' }, 'S', flash.treesitter, keymap_opts)
vim.keymap.set({ 'o' }, 'r', flash.remote, keymap_opts)
vim.keymap.set({ 'n', 'x', 'o' }, 'R', flash.treesitter_search, keymap_opts)
vim.keymap.set({ 'n', 'x', 'o' }, 'gl', jump_to_line)
