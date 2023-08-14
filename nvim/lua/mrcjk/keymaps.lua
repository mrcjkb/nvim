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
keymap.set('n', 'Y', 'y$', { silent = true })

-- Buffer list navigation
keymap.set('n', '[b', vim.cmd.bprevious, { silent = true })
keymap.set('n', ']b', vim.cmd.bnext, { silent = true })
keymap.set('n', '[B', vim.cmd.bfirst, { silent = true })
keymap.set('n', ']B', vim.cmd.blast, { silent = true })

-- Undo break points in insert mode
-- inoremap(',', ',<c-g>u')
-- inoremap( '.', '.<c-g>u')
-- inoremap('!', '!<c-g>u')
-- inoremap('?', '?<c-g>u')

-- Moving text
keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
keymap.set('v', 'K', ":m '>-2<CR>gv=gv")

-- Toggle the quickfix list (only opens if it is populated)
M.toggle_qf_list = function()
  local qf_exists = false
  for _, win in pairs(fn.getwininfo()) do
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

-- NOTE: This has to be passed as an Ex command because of https://github.com/unblevable/quick-scope/issues/88
keymap.set('n', '<C-c>', '<cmd>lua require("mrcjk.keymaps").toggle_qf_list()<CR>')

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
keymap.set('n', '[c', cleft, { silent = true })

local function cright()
  try_fallback_notify {
    try = vim.cmd.cnext,
    fallback = vim.cmd.cfirst,
    notify = 'Quickfix list is empty!',
  }
end

keymap.set('n', ']c', cright, { silent = true })
keymap.set('n', '[C', vim.cmd.cfirst, { silent = true })
keymap.set('n', ']C', vim.cmd.clast, { silent = true })
local function lleft()
  try_fallback_notify {
    try = vim.cmd.lprev,
    fallback = vim.cmd.llast,
    notify = 'Location list is empty!',
  }
end
keymap.set('n', '[l', lleft, { silent = true })
local function lright()
  try_fallback_notify {
    try = vim.cmd.lnext,
    fallback = vim.cmd.lfirst,
    notify = 'Location list is empty!',
  }
end
keymap.set('n', ']l', lright, { silent = true })
keymap.set('n', '[L', vim.cmd.lfirst, { silent = true })
keymap.set('n', ']L', vim.cmd.llast, { silent = true })

-- Resize vertical splits
local toIntegral = math.ceil
keymap.set('n', '<leader>+', function()
  local curWinWidth = api.nvim_win_get_width(0)
  api.nvim_win_set_width(0, toIntegral(curWinWidth * 3 / 2))
end, { silent = true })
keymap.set('n', '<leader>-', function()
  local curWinWidth = api.nvim_win_get_width(0)
  api.nvim_win_set_width(0, toIntegral(curWinWidth * 2 / 3))
end, { silent = true })
keymap.set('n', '<space>+', function()
  local curWinHeight = api.nvim_win_get_height(0)
  api.nvim_win_set_height(0, toIntegral(curWinHeight * 3 / 2))
end, { silent = true })
keymap.set('n', '<space>-', function()
  local curWinHeight = api.nvim_win_get_height(0)
  api.nvim_win_set_height(0, toIntegral(curWinHeight * 2 / 3))
end, { silent = true })

-- Remap Esc to switch to normal mode and Ctrl-Esc to pass Esc to terminal
keymap.set('t', '<Esc>', '<C-\\><C-n>')
keymap.set('t', '<C-Esc>', '<Esc>')

-- Shortcut for expanding to current buffer's directory in command mode
keymap.set('c', '%%', function()
  if fn.getcmdtype() == ':' then
    return fn.expand('%:h') .. '/'
  else
    return '%%'
  end
end, { expr = true })

keymap.set('n', 'tn', ':tabnew<CR>', {})

local severity = diagnostic.severity

local opts = { noremap = true, silent = true }
keymap.set('n', '<space>e', function()
  diagnostic.open_float(nil, { focus = false })
end, opts)
keymap.set('n', '[d', function()
  diagnostic.goto_prev {
    float = { focus = false },
  }
end, opts)
keymap.set('n', ']d', function()
  diagnostic.goto_next {
    float = { focus = false },
  }
end, opts)
keymap.set('n', '[e', function()
  diagnostic.goto_prev {
    severity = severity.ERROR,
    float = { focus = false },
  }
end, opts)
keymap.set('n', ']e', function()
  diagnostic.goto_next {
    severity = severity.ERROR,
    float = { focus = false },
  }
end, opts)
keymap.set('n', '[w', function()
  diagnostic.goto_prev {
    severity = severity.WARN,
    float = { focus = false },
  }
end, opts)
keymap.set('n', ']w', function()
  diagnostic.goto_next {
    severity = severity.WARN,
    float = { focus = false },
  }
end, opts)
keymap.set('n', '[h', function()
  diagnostic.goto_prev {
    severity = severity.HINT,
    float = { focus = false },
  }
end, opts)
keymap.set('n', ']h', function()
  diagnostic.goto_next {
    severity = severity.HINT,
    float = { focus = false },
  }
end, opts)
keymap.set('n', '<space>qa', function()
  diagnostic.setloclist { open = false }
end, opts)
keymap.set('n', '<space>ca', function()
  diagnostic.setqflist { open = false }
end, opts)
keymap.set('n', '<space>ce', function()
  diagnostic.setqflist { open = false, severity = severity.ERROR }
end, opts)
keymap.set('n', '<space>cw', function()
  diagnostic.setqflist { open = false, severity = severity.WARN }
end, opts)
keymap.set('n', '<space>ci', function()
  diagnostic.setqflist { open = false, severity = severity.INFO }
end, opts)
keymap.set('n', '<space>ch', function()
  diagnostic.setqflist { open = false, severity = severity.HINT }
end, opts)

return M
