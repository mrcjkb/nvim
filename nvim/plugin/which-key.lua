local which_key = require('which-key')
which_key.setup {
  layout = {
    height = { min = 4, max = 10 },
  },
  popup_mappings = {
    scroll_down = '<C-n>',
    scroll_up = '<C-p>',
  },
}
