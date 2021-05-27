local telescope = require'telescope'
local actions = require'telescope.actions'

telescope.setup {
  defaults = {
    mappings = {
      i = {
        ['<C-q>'] = actions.send_to_qflist,
      },
    }
  }
}
