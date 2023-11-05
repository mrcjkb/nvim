local M = {}

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
keymap.set('n', '[b', vim.cmd.bprevious, { silent = true, desc = 'previous buffer' })
keymap.set('n', ']b', vim.cmd.bnext, { silent = true, desc = 'next buffer' })
keymap.set('n', '[B', vim.cmd.bfirst, { silent = true, desc = 'first buffer' })
keymap.set('n', ']B', vim.cmd.blast, { silent = true, desc = 'last buffer' })

-- Undo break points in insert mode
-- inoremap(',', ',<c-g>u')
-- inoremap( '.', '.<c-g>u')
-- inoremap('!', '!<c-g>u')
-- inoremap('?', '?<c-g>u')

keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'move selection down' })
keymap.set('v', 'K', ":m '>-2<CR>gv=gv", { desc = 'move selection down' })

-- Toggle the quickfix list (only opens if it is populated)
local function toggle_qf_list()
  local qf_exists = false
  for _, win in pairs(fn.getwininfo() or {}) do
    if win['quickfix'] == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd.cclose()
    return
  end
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd.copen()
  end
end

keymap.set('n', '<C-c>', toggle_qf_list, { desc = 'toggle quickfix list' })

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

keymap.set('n', '[c', cleft, { silent = true, desc = 'cycle quickfix left' })
keymap.set('n', ']c', cright, { silent = true, desc = 'cycle quickfix right' })
keymap.set('n', '[C', vim.cmd.cfirst, { silent = true, desc = 'first quickfix entry' })
keymap.set('n', ']C', vim.cmd.clast, { silent = true, desc = 'last quickfix entry' })

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

keymap.set('n', '[l', lleft, { silent = true, desc = 'cycle loclist left' })
keymap.set('n', ']l', lright, { silent = true, desc = 'cycle loclist right' })
keymap.set('n', '[L', vim.cmd.lfirst, { silent = true, desc = 'first loclist entry' })
keymap.set('n', ']L', vim.cmd.llast, { silent = true, desc = 'last loclist entry' })

-- Resize vertical splits
local toIntegral = math.ceil
keymap.set('n', '<leader>w+', function()
  local curWinWidth = api.nvim_win_get_width(0)
  api.nvim_win_set_width(0, toIntegral(curWinWidth * 3 / 2))
end, { silent = true, desc = 'inc window width' })
keymap.set('n', '<leader>w-', function()
  local curWinWidth = api.nvim_win_get_width(0)
  api.nvim_win_set_width(0, toIntegral(curWinWidth * 2 / 3))
end, { silent = true, desc = 'dec window width' })
keymap.set('n', '<leader>h+', function()
  local curWinHeight = api.nvim_win_get_height(0)
  api.nvim_win_set_height(0, toIntegral(curWinHeight * 3 / 2))
end, { silent = true, desc = 'inc window height' })
keymap.set('n', '<leader>h-', function()
  local curWinHeight = api.nvim_win_get_height(0)
  api.nvim_win_set_height(0, toIntegral(curWinHeight * 2 / 3))
end, { silent = true, desc = 'dec window height' })

-- Close floating windows
keymap.set('n', '<leader>fq', function()
  vim.cmd('fclose!')
end, { silent = true, desc = 'close all floating windows' })

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

keymap.set('n', '<space>tn', vim.cmd.tabnew, { desc = 'new tab' })
keymap.set('n', '<space>tq', vim.cmd.tabclose, { desc = 'close tab' })

local severity = diagnostic.severity

keymap.set('n', '<space>e', function()
  local _, winid = diagnostic.open_float(nil, { scope = 'line' })
  vim.api.nvim_win_set_config(winid or 0, { focusable = true })
end, { noremap = true, silent = true, desc = 'diagnostics floating window' })
keymap.set('n', '[d', diagnostic.goto_prev, { noremap = true, silent = true, desc = 'previous diagnostic' })
keymap.set('n', ']d', diagnostic.goto_next, { noremap = true, silent = true, desc = 'next diagnostic' })
keymap.set('n', '[e', function()
  diagnostic.goto_prev {
    severity = severity.ERROR,
  }
end, { noremap = true, silent = true, desc = 'previous error diagnostic' })
keymap.set('n', ']e', function()
  diagnostic.goto_next {
    severity = severity.ERROR,
  }
end, { noremap = true, silent = true, desc = 'next error diagnostic' })
keymap.set('n', '[w', function()
  diagnostic.goto_prev {
    severity = severity.WARN,
  }
end, { noremap = true, silent = true, desc = 'previous warning diagnostic' })
keymap.set('n', ']w', function()
  diagnostic.goto_next {
    severity = severity.WARN,
  }
end, { noremap = true, silent = true, desc = 'next warning diagnostic' })
keymap.set('n', '[h', function()
  diagnostic.goto_prev {
    severity = severity.HINT,
  }
end, { noremap = true, silent = true, desc = 'previous hint diagnostic' })
keymap.set('n', ']h', function()
  diagnostic.goto_next {
    severity = severity.HINT,
  }
end, { noremap = true, silent = true, desc = 'next hint diagnostic' })
keymap.set('n', '<space>qa', function()
  diagnostic.setloclist { open = false }
end, { noremap = true, silent = true, desc = 'diagnostics to loclist' })
keymap.set('n', '<space>ca', function()
  diagnostic.setqflist { open = false }
end, { noremap = true, silent = true, desc = 'diagnostics to quickfix list' })
keymap.set('n', '<space>ce', function()
  diagnostic.setqflist { open = false, severity = severity.ERROR }
end, { noremap = true, silent = true, desc = 'error diagnostics to quickfix list' })
keymap.set('n', '<space>cw', function()
  diagnostic.setqflist { open = false, severity = severity.WARN }
end, { noremap = true, silent = true, desc = 'warning diagnostics to quickfix list' })
keymap.set('n', '<space>ci', function()
  diagnostic.setqflist { open = false, severity = severity.INFO }
end, { noremap = true, silent = true, desc = 'info diagnostics to quickfix list' })
keymap.set('n', '<space>ch', function()
  diagnostic.setqflist { open = false, severity = severity.HINT }
end, { noremap = true, silent = true, desc = 'hint diagnostics to quickfix list' })

local function toggle_spell_check()
  ---@diagnostic disable-next-line: param-type-mismatch vim.opt.spell = not (vim.opt.spell:get())
end

keymap.set('n', '<leader>S', toggle_spell_check, { noremap = true, silent = true, desc = 'toggle spell' })

keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'move down half-page and center' })
keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'move up half-page and center' })
keymap.set('n', '<C-f>', '<C-f>zz', { desc = 'move down full-page and center' })
keymap.set('n', '<C-b>', '<C-b>zz', { desc = 'move up full-page and center' })

-- Helix 23.10 style smart tab

local function is_line_start()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  local current_line_text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
  local preceding_text = vim.print(current_line_text:sub(1, col))
  return preceding_text:match('%S') == nil
end

local skips = { 'string_content' }

---@param node_type string
local function should_skip(node_type)
  for _, skip in ipairs(skips) do
    if type(skip) == 'string' and skip == node_type then
      return true
    elseif type(skip) == 'function' and skip(node_type) then
      return true
    end
  end
  return false
end

local function smart_tab(check)
  local node = vim.treesitter.get_node()
  if not node then
    return check and '<tab>' or nil
  end
  while should_skip(node:type()) do
    node = node:parent()
    if not node then
      return check and '<tab>' or nil
    end
  end
  if check then
    return '<plug>(smart-tab)'
  end
  local row, col = node:end_()
  local ok = pcall(api.nvim_win_set_cursor, 0, { row + 1, col })
  if not ok then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<tab>', true, true, true), 'n', true)
  end
end

-- NOTE: this allows cursor movement on expr mapping
keymap.set('i', '<plug>(smart-tab)', smart_tab)

keymap.set('i', '<tab>', function()
  local non_treesitter = not pcall(vim.treesitter.get_node)
  if non_treesitter or is_line_start() then
    return '<tab>'
  else
    return smart_tab(true)
  end
end, { desc = 'smart-tab', expr = true })

-- plugin keymaps

keymap.set('n', '<leader>fg', function()
  vim.cmd.FzfLua('grep')
end, { desc = 'FzfLua grep' })

keymap.set('n', '<leader>ff', function()
  vim.cmd.FzfLua()
end, { desc = 'FzfLua' })

return M
