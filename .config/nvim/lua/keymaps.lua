local cmd = vim.cmd
local api = vim.api
local fn = vim.fn
local keymap = vim.keymap


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
keymap.set('n', '<C-c>', function()
  local qf_exists = false
  for _, win in pairs(fn.getwininfo()) do
    if win["quickfix"] == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    cmd 'cclose'
    return
  end
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    cmd 'copen'
  end
end)

-- Cycle the quickfix and location lists
keymap.set('n', '[c',  'try | cnext | catch | cfirst | catch | endtry <CR>' , {})
keymap.set('n', ']c',  'try | cprev | catch | clast | catch | endtry <CR>' , {})
keymap.set('n', '[C',  'cfirst' , {})
keymap.set('n', ']C',  'clast' , {})
keymap.set('n', '[l',  'try | lnext | catch | lfirst | catch | endtry <CR>' , {})
keymap.set('n', ']l',  'try | lprev | catch | llast | catch | endtry <CR>' , {})
keymap.set('n', '[L',  'lfirst' , {})
keymap.set('n', ']L',  'llast' , {})

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
keymap.set('t', '<C-v>',  '<Esc')

-- Shortcut for expanding to current buffer's directory in command mode
keymap.set('c', '%%', function()
  if fn.getcmdtype() == ':' then
    return fn.expand('%:h') .. '/' 
  else
    return '%%'
  end
end, {expr = true,})
