---@class termopen.Opts
---@field insert? boolean
---@field disable_line_numbers? boolean

---@param opts? termopen.Opts
local function extend_default_opts(opts)
  opts = opts or {}
  opts.insert = opts.insert == nil and true or opts.insert
  return opts
end

---@param cmd string
---@param opts? termopen.Opts
local function termopen(cmd, opts)
  opts = extend_default_opts(opts)
  vim.cmd.tabnew()
  local buf = vim.api.nvim_get_current_buf()
  vim.fn.jobstart(cmd, {
    on_exit = function()
      vim.api.nvim_buf_delete(buf, {})
    end,
    term = true,
  })
  if opts.insert then
    vim.cmd.startinsert()
  end
  if opts.disable_line_numbers then
    vim.opt.number = false
    vim.opt.relativenumber = false
  end
end

vim.keymap.set('n', '<leader>go', function()
  termopen('gitu')
end, { noremap = true, silent = true, desc = '[g]itu: [o]pen' })

vim.keymap.set('n', '<leader>jj', function()
  termopen('lazyjj', {
    disable_line_numbers = true,
  })
end, { noremap = true, silent = true, desc = 'lazy[j][j]' })

vim.api.nvim_create_autocmd('TermOpen', {
  callback = function()
    vim.opt.relativenumber = true
  end,
  group = vim.api.nvim_create_augroup('terminal-set-relative-number', { clear = true }),
})
