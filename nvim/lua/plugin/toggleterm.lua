require('toggleterm').setup {
  size = function(term)
    if term.direction == 'horizontal' then
      return vim.o.lines / 2
    elseif term.direction == 'vertical' then
      return vim.o.columns / 2
    end
  end,
  open_mapping = [[<M-t>]],
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 1, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
  start_in_insert = true,
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  persist_size = true,
  -- direction = 'vertical' | 'horizontal' | 'window' | 'float',
  direction = 'vertical',
  close_on_exit = false, -- close the terminal window when the process exits
  -- shell = vim.o.shell, -- change the default shell
  -- This field is only relevant if direction is set to 'float'
  autochdir = false,
}

vim.cmd.set('hidden') -- Required to persist toggleterm sessions
