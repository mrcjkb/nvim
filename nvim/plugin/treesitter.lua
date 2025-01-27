-- Files that have trouble with syntax highlighting

local files = require('mrcjk.files')

---@diagnostic disable: missing-fields
local configs = require('nvim-treesitter.configs')
configs.setup {
  -- ensure_installed = 'all',
  -- auto_install = false, -- Do not automatically install missing parsers when entering buffer
  highlight = {
    enable = true,
    disable = function(_, buf)
      return files.disable_treesitter_features(buf)
    end,
  },
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
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { 'BufWrite', 'CursorHold' },
  },
}

require('treesitter-context').setup {
  max_lines = 3,
}
