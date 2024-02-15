local api = vim.api

if vim.fn.has_key(vim.fn.environ(), 'TMUX') == 1 then
  vim.system { 'tmux', 'set', 'status', 'off' } -- toggle of immediately
  local tmuxgroup = api.nvim_create_augroup('tmux_status_toggle', { clear = true })
  api.nvim_create_autocmd({ 'VimEnter', 'VimResume' }, {
    pattern = '*',
    group = tmuxgroup,
    callback = function()
      vim.system { 'tmux', 'set', 'status', 'off' }
    end,
  })
  api.nvim_create_autocmd({ 'VimLeave', 'VimSuspend' }, {
    pattern = '*',
    group = tmuxgroup,
    callback = function()
      vim.system { 'tmux', 'set', 'status', 'on' }
    end,
  })
  require('tmux').setup {}
end
