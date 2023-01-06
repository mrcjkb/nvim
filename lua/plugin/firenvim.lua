local M = {}

M.run = function()
  vim.fn['firenvim#install'](0)
end

M.setup = function()
  vim.g.firenvim_config = {
    globalSettings = {
      alt = 'all',
    },
    localSettings = {
      ['https://app.slack.com/'] = { takover = 'never', priority = 1 },
    },
  }
end
M.config = function()
  vim.api.nvim_create_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup('firenvim_gitlab', {}),
    pattern = 'gitlab.internal.tiko.ch_*.txt',
    callback = function()
      vim.cmd.setf('markdown')
    end,
  })
  vim.api.nvim_create_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup('firenvim_gihub', {}),
    pattern = 'github.com_*.txt',
    callback = function()
      vim.cmd.setf('markdown')
    end,
  })
end
return M
