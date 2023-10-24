---@diagnostic disable: missing-fields
local wf = require('wf')
wf.setup()

local which_key = require('wf.builtin.which_key')

-- Which Key
vim.keymap.set(
  'n',
  '<leader>ww',
  which_key { text_insert_in_advance = '' },
  { noremap = true, silent = true, desc = '[wf.nvim] which-key' }
)
