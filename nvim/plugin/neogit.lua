local keymap_opts = { noremap = true, silent = true }
---neogit's setup is quite heavy, so this lazy-loads on keymaps
---@param open_args table|nil the arguments to pass to neogit.open
local function init(open_args)
  local neogit = require('neogit')

  neogit.setup {
    disable_builtin_notifications = true,
    disable_insert_on_commit = 'auto',
    integrations = {
      diffview = true,
      telescope = true,
      fzf_lua = true,
    },
    sections = {
      ---@diagnostic disable-next-line: missing-fields
      recent = {
        folded = false,
      },
    },
  }
  vim.keymap.del('n', '<leader>go', keymap_opts)
  vim.keymap.set('n', '<leader>go', neogit.open, keymap_opts)
  vim.keymap.del('n', '<leader>gs', keymap_opts)
  vim.keymap.set('n', '<leader>gs', function()
    neogit.open { kind = 'auto' }
  end, keymap_opts)
  vim.keymap.del('n', '<leader>gc', keymap_opts)
  vim.keymap.set('n', '<leader>gc', function()
    neogit.open { 'commit' }
  end, keymap_opts)
  neogit.open(open_args)
end

vim.keymap.set('n', '<leader>go', function()
  init()
end, keymap_opts)
vim.keymap.set('n', '<leader>gs', function()
  init { kind = 'auto' }
end, keymap_opts)
vim.keymap.set('n', '<leader>gc', function()
  init { 'commit' }
end, keymap_opts)
