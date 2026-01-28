---@class termopen.Opts
---@field insert? boolean
---@field disable_line_numbers? boolean

vim.api.nvim_create_autocmd('TermOpen', {
  callback = function()
    vim.opt.relativenumber = true
  end,
  group = vim.api.nvim_create_augroup('terminal-set-relative-number', { clear = true }),
})
