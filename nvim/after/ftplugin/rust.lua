local bufnr = vim.api.nvim_get_current_buf()
if vim.b[bufnr].mrcjkb_did_ftplugin then
  return
end
vim.b[bufnr].mrcjkb_did_ftplugin = true

local function desc(description)
  return { noremap = true, silent = true, buffer = bufnr, desc = description }
end

vim.keymap.set('n', '<space>rdd', function()
  vim.cmd.RustLsp('debuggables')
end, desc('rust: debuggables'))
vim.keymap.set('n', '<space>rdl', function()
  vim.cmd.RustLsp { 'debuggables', bang = true }
end, desc('rust: run last debuggable'))
vim.keymap.set('n', '<space>rr', function()
  vim.cmd.RustLsp('runnables')
end, desc('rust: runnables'))
vim.keymap.set('n', '<space>rl', function()
  vim.cmd.RustLsp { 'runnables', bang = true }
end, desc('rust: run last runnable'))
vim.keymap.set('n', '<space>rme', function()
  vim.cmd.RustLsp('expandMacro')
end, desc('rust: expand macro'))
vim.keymap.set('n', '<space>rk', function()
  vim.cmd.RustLsp { 'moveItem', 'up' }
end, desc('rust: move item up'))
vim.keymap.set('n', '<space>rj', function()
  vim.cmd.RustLsp { 'moveItem', 'down' }
end, desc('rust: move item down'))
vim.keymap.set('v', 'K', function()
  vim.cmd.RustLsp { 'hover', 'range' }
end, desc('rust: hover range'))
vim.keymap.set('n', '<space>re', function()
  vim.cmd.RustLsp('explainError')
end, desc('rust: explain error'))
vim.keymap.set('n', '<space>rd', function()
  vim.cmd.RustLsp('renderDiagnostic')
end, desc('rust: render diagnostic'))
vim.keymap.set('n', '<space>gc', function()
  vim.cmd.RustLsp('openCargo')
end, desc('rust: open Cargo.toml'))
vim.keymap.set('n', '<space>gp', function()
  vim.cmd.RustLsp('parentModule')
end, desc('rust: open parent module'))
vim.keymap.set('n', 'J', function()
  vim.cmd.RustLsp('joinLines')
end, desc('rust: join lines'))
vim.keymap.set('n', '<space>rs', function()
  vim.cmd.RustLsp('ssr')
end, desc('rust: SSR'))
