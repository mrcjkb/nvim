if vim.g.loaded_highlight_trailing_whitespace then
  return
end
vim.g.loaded_highlight_trailing_whitespace = true


local api = vim.api

local function should_highlight_trailing_whitespace()
  local ignored_filetypes = {
    'TelescopePrompt',
    'help',
    'dashboard',
  }
  if vim.bo.buftype == 'nofile' or vim.bo.buftype == 'terminal' then
    return false
  end
  if vim.tbl_contains(ignored_filetypes, vim.bo.filetype) then
    return false
  end
  if api.nvim_get_mode().mode == 'i' then
    return false
  end
  local bufnr = api.nvim_get_current_buf()
  require('editorconfig')
  local editorconfig = vim.b[bufnr].editorconfig or {}
  if editorconfig.trim_trailing_whitespace == 'true' then
    return false
  end
  return true
end

api.nvim_create_autocmd({ 'UIEnter' }, {
  group = api.nvim_create_augroup('HighlightTrailingWhiteSpace', {}),
  callback = function()
    local extra_whitespace_hi = 'DiffDelete'
    if not vim.fn.hlexists(extra_whitespace_hi) then
      vim.notify_once(string.format('highlight %s does not exist', extra_whitespace_hi), vim.log.levels.ERROR)
      return
    end
    if should_highlight_trailing_whitespace() then
      vim.cmd.match { extra_whitespace_hi, [[/\s\+$/]] }
    else
      vim.cmd.match()
    end
  end,
})
