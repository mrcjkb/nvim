local api = vim.api
local fn = vim.fn
local keymap = vim.keymap
local diagnostic = vim.diagnostic

-- Automatic management of search highlight
local auto_hlsearch_namespace = vim.api.nvim_create_namespace('auto_hlsearch')
vim.on_key(function(char)
  if vim.fn.mode() == 'n' then
    vim.opt.hlsearch = vim.tbl_contains({ '<CR>', 'n', 'N', '*', '#', '?', '/' }, vim.fn.keytrans(char))
  end
end, auto_hlsearch_namespace)

-- Yank from current position till end of current line
keymap.set('n', 'Y', 'y$', { silent = true, desc = 'yank to end of line' })

-- Buffer list navigation
keymap.set('n', '[b', vim.cmd.bprevious, { silent = true, desc = 'previous [b]uffer' })
keymap.set('n', ']b', vim.cmd.bnext, { silent = true, desc = 'next [b]uffer' })
keymap.set('n', '[B', vim.cmd.bfirst, { silent = true, desc = 'first [B]uffer' })
keymap.set('n', ']B', vim.cmd.blast, { silent = true, desc = 'last [B]uffer' })

local function try_fallback_notify(opts)
  local success, _ = pcall(opts.try)
  if success then
    return
  end
  success, _ = pcall(opts.fallback)
  if success then
    return
  end
  vim.notify(opts.notify, vim.log.levels.INFO)
end

-- Cycle the quickfix and location lists
local function cleft()
  try_fallback_notify {
    try = vim.cmd.cprev,
    fallback = vim.cmd.clast,
    notify = 'Quickfix list is empty!',
  }
end

local function cright()
  try_fallback_notify {
    try = vim.cmd.cnext,
    fallback = vim.cmd.cfirst,
    notify = 'Quickfix list is empty!',
  }
end

keymap.set('n', '[c', cleft, { silent = true, desc = '[c]ycle quickfix left' })
keymap.set('n', ']c', cright, { silent = true, desc = '[c]ycle quickfix right' })
keymap.set('n', '[C', vim.cmd.cfirst, { silent = true, desc = 'first quickfix entry [C]' })
keymap.set('n', ']C', vim.cmd.clast, { silent = true, desc = 'last quickfix entry [C]' })

local function lleft()
  try_fallback_notify {
    try = vim.cmd.lprev,
    fallback = vim.cmd.llast,
    notify = 'Location list is empty!',
  }
end

local function lright()
  try_fallback_notify {
    try = vim.cmd.lnext,
    fallback = vim.cmd.lfirst,
    notify = 'Location list is empty!',
  }
end

keymap.set('n', '[l', lleft, { silent = true, desc = 'cycle [l]oclist left' })
keymap.set('n', ']l', lright, { silent = true, desc = 'cycle [l]oclist right' })
keymap.set('n', '[L', vim.cmd.lfirst, { silent = true, desc = 'first [L]oclist entry' })
keymap.set('n', ']L', vim.cmd.llast, { silent = true, desc = 'last [L]oclist entry' })

-- Resize vertical splits
local toIntegral = math.ceil
keymap.set('n', '<leader>w+', function()
  local curWinWidth = api.nvim_win_get_width(0)
  api.nvim_win_set_width(0, toIntegral(curWinWidth * 3 / 2))
end, { silent = true, desc = 'inc window [w]idth' })
keymap.set('n', '<leader>w-', function()
  local curWinWidth = api.nvim_win_get_width(0)
  api.nvim_win_set_width(0, toIntegral(curWinWidth * 2 / 3))
end, { silent = true, desc = 'dec window [w]idth' })
keymap.set('n', '<leader>h+', function()
  local curWinHeight = api.nvim_win_get_height(0)
  api.nvim_win_set_height(0, toIntegral(curWinHeight * 3 / 2))
end, { silent = true, desc = 'inc window [h]eight' })
keymap.set('n', '<leader>h-', function()
  local curWinHeight = api.nvim_win_get_height(0)
  api.nvim_win_set_height(0, toIntegral(curWinHeight * 2 / 3))
end, { silent = true, desc = 'dec window [h]eight' })

-- Close floating windows
keymap.set('n', '<leader>fq', function()
  vim.cmd('fclose!')
end, { silent = true, desc = '[f]loating windows [q]uit all' })

-- Remap Esc to switch to normal mode and Ctrl-Esc to pass Esc to terminal
keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'switch to normal mode' })
keymap.set('t', '<C-Esc>', '<Esc>', { desc = 'send Esc to terminal' })

-- Shortcut for expanding to current buffer's directory in command mode
keymap.set('c', '%%', function()
  if fn.getcmdtype() == ':' then
    return fn.expand('%:h') .. '/'
  else
    return '%%'
  end
end, { expr = true, desc = "expand to current buffer's directory" })

keymap.set('n', '<space>tn', vim.cmd.tabnew, { desc = '[t]ab new' })
keymap.set('n', '<space>tq', vim.cmd.tabclose, { desc = '[t]ab [q]uit' })

local severity = diagnostic.severity

keymap.set('n', '<space>do', function()
  local _, winid = diagnostic.open_float(nil, { scope = 'line' })
  vim.api.nvim_win_set_config(winid or 0, { focusable = true })
end, { noremap = true, silent = true, desc = '[d]iagnostics [o]pen floating' })
keymap.set('n', '[d', function()
  diagnostic.jump { count = -1, float = true }
end, { noremap = true, silent = true, desc = 'previous [d]iagnostic' })
keymap.set('n', ']d', function()
  diagnostic.jump { count = 1, float = true }
end, { noremap = true, silent = true, desc = 'next [d]iagnostic' })
keymap.set('n', '[e', function()
  diagnostic.jump {
    severity = severity.ERROR,
    count = -1,
    float = true,
  }
end, { noremap = true, silent = true, desc = 'previous [e]rror' })
keymap.set('n', ']e', function()
  diagnostic.jump {
    severity = severity.ERROR,
    count = 1,
    float = true,
  }
end, { noremap = true, silent = true, desc = 'next [e]rror' })
keymap.set('n', '[w', function()
  diagnostic.jump {
    severity = severity.WARN,
    count = -1,
    float = true,
  }
end, { noremap = true, silent = true, desc = 'previous [w]arning' })
keymap.set('n', ']w', function()
  diagnostic.jump {
    severity = severity.WARN,
    count = 1,
    float = true,
  }
end, { noremap = true, silent = true, desc = 'next [w]arning' })
keymap.set('n', '<space>dl', function()
  diagnostic.setloclist { open = false }
end, { noremap = true, silent = true, desc = '[d]iagnostics to [l]oclist' })
keymap.set('n', '<space>dc', function()
  diagnostic.setqflist { open = false }
end, { noremap = true, silent = true, desc = '[d]iagnostics to quickfix list [c]' })
keymap.set('n', '<space>ce', function()
  diagnostic.setqflist { open = false, severity = severity.ERROR }
end, { noremap = true, silent = true, desc = '[c] [e]rror diagnostics to quickfix list' })
keymap.set('n', '<space>cw', function()
  diagnostic.setqflist { open = false, severity = severity.WARN }
end, { noremap = true, silent = true, desc = '[c] [w]arning diagnostics to quickfix list' })
keymap.set('n', '<space>ci', function()
  diagnostic.setqflist { open = false, severity = severity.INFO }
end, { noremap = true, silent = true, desc = '[c] [i]nfo diagnostics to quickfix list' })
keymap.set('n', '<space>ch', function()
  diagnostic.setqflist { open = false, severity = severity.HINT }
end, { noremap = true, silent = true, desc = '[c] [h]int diagnostics to quickfix list' })

local function buf_toggle_diagnostics()
  local filter = { bufnr = api.nvim_get_current_buf() }
  diagnostic.enable(not diagnostic.is_enabled(filter), filter)
end

keymap.set('n', '<space>dt', buf_toggle_diagnostics)

local function toggle_spell_check()
  ---@diagnostic disable-next-line: param-type-mismatch vim.opt.spell = not (vim.opt.spell:get())
end

keymap.set('n', '<leader>S', toggle_spell_check, { noremap = true, silent = true, desc = 'toggle [S]pell' })

keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'move down half-page and center' })
keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'move up half-page and center' })
keymap.set('n', '<C-f>', '<C-f>zz', { desc = 'move down full-page and center' })
keymap.set('n', '<C-b>', '<C-b>zz', { desc = 'move up full-page and center' })
keymap.set('n', '<C-}>', '<C-}>zz', { desc = 'move up full-page and center' })

-- Terminal
keymap.set('n', '<M-t>', function()
  local term_bufnr = vim.iter(vim.api.nvim_list_bufs()):find(function(bufnr)
    local name = vim.api.nvim_buf_get_name(bufnr)
    return vim.startswith(name, 'term://')
  end)
  if term_bufnr then
    vim.api.nvim_set_current_buf(term_bufnr)
  else
    vim.cmd.terminal()
  end
end, { silent = true, noremap = true, desc = 'terminal' })
keymap.set('n', '<M-v>', function()
  vim.cmd.vsplit()
  vim.cmd.terminal()
end, { silent = true, noremap = true, desc = 'terminal [v]ertical split' })
keymap.set('n', '<M-h>', function()
  vim.cmd.split()
  vim.cmd.terminal()
end, { silent = true, noremap = true, desc = 'terminal [h]orizontal split' })
