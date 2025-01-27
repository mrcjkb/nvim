-- Files that have trouble with syntax highlighting

---@diagnostic disable: missing-fields
local configs = require('nvim-treesitter.configs')
configs.setup {
  indent = {
    enable = true,
  },
  matchup = {
    enable = true, -- mandatory, false will disable the whole extension
    disable = { 'python' },
  },
  incremental_selection = {
    enable = false,
  },
}

require('treesitter-context').setup {
  max_lines = 3,
}
