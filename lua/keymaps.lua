local cmd = vim.cmd
local api = vim.api
local fn = vim.fn
local keymap = vim.keymap
local diagnostic = vim.diagnostic


-- Turn off search highlight by mapping :nohlsearch to space
keymap.set('n','<leader><space>', ':nohlsearch<CR>', {silent = true,})

-- Yank from current position till end of current line
keymap.set('n','Y', 'y$', {silent = true,})

-- Buffer list navigation
keymap.set('n','[b', ':bprevious<CR>', {silent = true,})
keymap.set('n',']b', ':bnext<CR>', {silent = true,})
keymap.set('n','[B', ':bfirst<CR>', {silent = true,})
keymap.set('n',']B', ':blast<CR>', {silent = true,})

-- Undo break points in insert mode 
-- inoremap(',', ',<c-g>u')
-- inoremap( '.', '.<c-g>u')
-- inoremap('!', '!<c-g>u')
-- inoremap('?', '?<c-g>u')

-- Moving text
keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
keymap.set('v', 'K', ":m '>-2<CR>gv=gv")
keymap.set('v', '<leader>j', ':m .+1<CR>==')
keymap.set('v', '<leader>k', ':m .-2<CR>==')

-- Toggle the quickfix list (only opens if it is populated)
-- NOTE: This has to be passed as an Ex command because of https://github.com/unblevable/quick-scope/issues/88
keymap.set('n', '<C-c>', '<cmd>lua require("keymap-utils").toggle_qf_list()<CR>')

-- Cycle the quickfix and location lists
keymap.set('n', '[c',  function()
  cmd 'try | cprev | catch | try | clast | catch | echo "Quickfix list is empty!" | endtry'
end , {})
keymap.set('n', ']c',  function() 
  cmd 'try | cnext | catch | try | cfirst | catch | echo "Quickfix list is empty!" | endtry'
end, {})
keymap.set('n', '[C',  ':cfirst<CR>' , {})
keymap.set('n', ']C',  ':clast<CR>' , {})
keymap.set('n', '[l',  function()
  cmd 'try | lprev | catch | try | llast | catch | echo "Location list is empty!" | endtry'
end, {})
keymap.set('n', ']l',  function()
  cmd 'try | lnext | catch | try | lfirst | catch | echo "Location list is empty!" | endtry'
end, {})
keymap.set('n', '[L',  ':lfirst<CR>' , {})
keymap.set('n', ']L',  ':llast<CR>' , {})

-- Resize vertical splits
keymap.set('n', '<leader>+',  function()
  local curWinWidth = api.nvim_win_get_width(0)
  api.nvim_win_set_width(0, curWinWidth * 3 / 2)
end, {silent = true,})
keymap.set('n', '<leader>-',  function()
  local curWinWidth = api.nvim_win_get_width(0)
  api.nvim_win_set_width(0, curWinWidth * 2 / 3)
end, {silent = true,})
keymap.set('n', '<space>+',  function()
  local curWinHeight = api.nvim_win_get_height(0)
  api.nvim_win_set_height(0, curWinHeight * 3 / 2)
end, {silent = true,})
keymap.set('n', '<space>-',  function()
  local curWinHeight = api.nvim_win_get_height(0)
  api.nvim_win_set_height(0, curWinHeight * 2 / 3)
end, {silent = true,})

-- Remap Esc to switch to normal mode and Ctrl-Esc to pass Esc to terminal
keymap.set('t', '<Esc>', '<C-\\><C-n>')
keymap.set('t', '<C-v>',  '<Esc>')

-- Shortcut for expanding to current buffer's directory in command mode
keymap.set('c', '%%', function()
  if fn.getcmdtype() == ':' then
    return fn.expand('%:h') .. '/'
  else
    return '%%'
  end
end, {expr = true,})

local opts = { noremap=true, silent=true }
keymap.set('n', '<space>e', diagnostic.open_float, opts)
keymap.set('n', '[d', diagnostic.goto_prev, opts)
keymap.set('n', ']d', diagnostic.goto_next, opts)
keymap.set('n', '[e', function() diagnostic.goto_prev({ severity='ERROR' }) end, opts)
keymap.set('n', ']e', function() diagnostic.goto_next({ severity='ERROR' }) end, opts)
keymap.set('n', '[w', function() diagnostic.goto_prev({ severity='WARN' }) end, opts)
keymap.set('n', ']w', function() diagnostic.goto_next({ severity='WARN' }) end, opts)
keymap.set('n', '[i', function() diagnostic.goto_prev({ severity='INFO' }) end, opts)
keymap.set('n', ']i', function() diagnostic.goto_next({ severity='INFO' }) end, opts)
keymap.set('n', '<space>q', function() diagnostic.set_loclist({ open_loclist=false }) end, opts)
keymap.set('n', '<space>c', function() diagnostic.set_qflist( {open_qflist=false }) end, opts)
keymap.set('n', '<space>w', function() diagnostic.set_qflist( {open_qflist=false, severity = 'WARN' }) end, opts)
keymap.set('n', '<space>i', function() diagnostic.set_qflist( {open_qflist=false, severity = 'INFO' }) end, opts)

