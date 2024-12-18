---@class termopen.Opts
---@field insert? boolean
---@field disable_line_numbers? boolean

---@param cmd string
---@param opts? termopen.Opts
local function termopen(cmd, opts)
  opts = opts or {}
  opts.insert = opts.insert == nil and true or opts.insert
  vim.cmd.tabnew()
  if opts.disable_line_numbers then
    vim.opt.number = false
    vim.opt.relativenumber = false
  end
  local buf = vim.api.nvim_get_current_buf()
  vim.fn.termopen(cmd, {
    on_exit = function()
      vim.api.nvim_buf_delete(buf, {})
    end,
  })
  if opts.insert then
    vim.cmd.startinsert()
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

vim.keymap.set('n', '<leader>jd', function()
  termopen('jj describe')
end, { noremap = true, silent = true, desc = '[j]j: [d]escribe' })
