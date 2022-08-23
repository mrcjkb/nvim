local cmd = vim.cmd
local fn = vim.fn

local M = {}

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

return M
