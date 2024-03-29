local open_mapping = '<M-t>'
local opts = { silent = true, noremap = true, desc = 'toggleterm' }
vim.keymap.set('n', open_mapping, function()
  vim.keymap.del('n', open_mapping, opts)
  require('toggleterm').setup {
    size = function(term)
      if term.direction == 'horizontal' then
        return vim.o.lines / 2
      elseif term.direction == 'vertical' then
        return vim.o.columns / 2
      end
    end,
    open_mapping = open_mapping,
    hide_numbers = false, -- hide the number column in toggleterm buffers
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 1, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
    start_in_insert = true,
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    persist_size = true,
    -- direction = 'vertical' | 'horizontal' | 'tab' | 'float',
    direction = 'horizontal',
    close_on_exit = false, -- close the terminal window when the process exits
    -- shell = vim.o.shell, -- change the default shell
    auto_scroll = false,
    -- This field is only relevant if direction is set to 'float'
    autochdir = false,
    winbar = {
      enabled = true,
    },
  }
  vim.cmd.set('hidden') -- Required to persist toggleterm sessions
  vim.cmd.ToggleTerm()
end, opts)
