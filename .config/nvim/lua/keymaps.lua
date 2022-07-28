local api = vim.api
local cmd = vim.cmd
local fn = vim.fn

local silentnnoremap = function(keys, cmd)
  api.nvim_set_keymap('n', keys, cmd, {noremap = true, silent = true})
end

local nnoremap = function(keys, cmd)
  api.nvim_set_keymap('n', keys, cmd, {noremap = true,})
end

-- local inoremap = function(keys, cmd)
--   api.nvim_set_keymap('i', keys, cmd, {noremap = true,})
-- end

local vnoremap = function(keys, cmd)
  api.nvim_set_keymap('v', keys, cmd, {noremap = true,})
end

-- Turn off search highlight by mapping :nohlsearch to space
silentnnoremap('<leader><space>', ':nohlsearch<CR>')

-- Yank from current position till end of current line
silentnnoremap('Y', 'y$')

-- Buffer list navigation
silentnnoremap('[b', ':bprevious<CR>')
silentnnoremap(']b', ':bnext<CR>')
silentnnoremap('[B', ':bfirst<CR>')
silentnnoremap(']B', ':blast<CR>')

-- Undo break points in insert mode 
-- inoremap(',', ',<c-g>u')
-- inoremap( '.', '.<c-g>u')
-- inoremap('!', '!<c-g>u')
-- inoremap('?', '?<c-g>u')

-- Moving text
vnoremap('J', ":m '>+1<CR>gv=gv")
vnoremap('K', ":m '>-2<CR>gv=gv")
nnoremap('<leader>j', ':m .+1<CR>==')
nnoremap('<leader>k', ':m .-2<CR>==')

local M = {}

-- Toggle the quickfix list (only opens if it is populated)
M.toggle_qf_list = function()
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
end

silentnnoremap('<C-c>', ":lua require('keymaps').toggle_qf_list()<CR>")

return M
