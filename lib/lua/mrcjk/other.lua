local M = {}

M.set_keymaps = function()
  local bufnr = vim.api.nvim_get_current_buf()

  local function desc(description)
    return { noremap = true, silent = true, desc = description, buffer = bufnr }
  end

  vim.keymap.set('n', '<leader>oo', function()
    vim.cmd.Other()
  end, desc('[oo]ther'))

  vim.keymap.set('n', '<leader>os', function()
    vim.cmd.Other('spec')
  end, desc('[o]ther: [s]pec'))

  vim.keymap.set('n', '<leader>ot', function()
    vim.cmd.Other('test')
  end, desc('[o]ther: [t]est'))

  vim.keymap.set('n', '<leader>oi', function()
    vim.cmd.Other('impl')
  end, desc('[o]ther: [i]mpl'))

  vim.keymap.set('n', '<leader>oI', function()
    vim.cmd.Other('internal-impl')
  end, desc('[o]ther: [I]nternal-impl'))

  vim.keymap.set('n', '<leader>on', function()
    vim.cmd.Other('internal')
  end, desc('[o]ther: i[n]ternal'))
end

return M
