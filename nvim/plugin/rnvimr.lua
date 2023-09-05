-- Do not make Ranger replace netrw and be the file explorer
vim.g.rnvimr_ex_enable = 0
-- Make Neovim wipe the buffers corresponding to the files deleted by Ranger
vim.g.rnvimr_enable_bw = 1
-- Map Rnvimr action
vim.g.rnvimr_action = {
  ['<C-t>'] = 'NvimEdit tabedit',
  ['<C-x>'] = 'NvimEdit split',
  ['<C-v>'] = 'NvimEdit vsplit',
  ['gw'] = 'JumpNvimCwd',
  ['gf'] = 'AttachFile',
  ['yw'] = 'EmitRangerCwd',
}

vim.keymap.set('t', '<M-i>', '<C-\\><C-n>:RnvimrResize<CR>', { silent = true })
vim.keymap.set({ 'n', 't' }, '<M-r>', vim.cmd.RnvimrToggle, { silent = true })
