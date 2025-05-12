local api = vim.api

api.nvim_create_user_command('DeleteOtherBufs', '%bd|e#', {})
-- delete current buffer
api.nvim_create_user_command('Q', function()
  vim.cmd.bd('%')
end, {})
api.nvim_create_user_command('W', function()
  vim.cmd.w()
end, {})

-- Pandoc shortcut
api.nvim_create_user_command(
  'Pd',
  'split | resize 10 | terminal pandoc % -f markdown-implicit_figures -s -o <args>',
  { nargs = '*' }
)

api.nvim_create_user_command('LspStop', function(kwargs)
  local name = kwargs.fargs[1]
  for _, client in pairs(vim.lsp.get_clients { buffer = 0 }) do
    if client.name == name then
      client:stop(true)
    end
  end
end, {
  nargs = 1,
  complete = function()
    return vim.tbl_map(function(c)
      return c.name
    end, vim.lsp.get_clients { buffer = 0 })
  end,
})
