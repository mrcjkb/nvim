local cfg = {
  opleader = { line = 'gc', block = 'gb' },
  toggler = {
    line = 'gcc',
    block = 'gbc',
  },
}

vim.keymap.set('n', cfg.opleader.line, '<Plug>(comment_toggle_linewise)', { desc = 'Comment toggle linewise' })
vim.keymap.set('n', cfg.opleader.block, '<Plug>(comment_toggle_blockwise)', { desc = 'Comment toggle blockwise' })

vim.keymap.set('n', cfg.toggler.line, function()
  return vim.api.nvim_get_vvar('count') == 0 and '<Plug>(comment_toggle_linewise_current)'
    or '<Plug>(comment_toggle_linewise_count)'
end, { expr = true, desc = 'Comment toggle current line' })
vim.keymap.set('n', cfg.toggler.block, function()
  return vim.api.nvim_get_vvar('count') == 0 and '<Plug>(comment_toggle_blockwise_current)'
    or '<Plug>(comment_toggle_blockwise_count)'
end, { expr = true, desc = 'Comment toggle current block' })

-- VISUAL mode mappings
vim.keymap.set(
  'x',
  cfg.opleader.line,
  '<Plug>(comment_toggle_linewise_visual)',
  { desc = 'Comment toggle linewise (visual)' }
)

vim.keymap.set(
  'x',
  cfg.opleader.block,
  '<Plug>(comment_toggle_blockwise_visual)',
  { desc = 'Comment toggle blockwise (visual)' }
)
