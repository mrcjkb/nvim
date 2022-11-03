require('material').setup({
  contrast = {
    terminal = true,
    floating_windows = true,
    cursor_line = true,
    non_current_windows = true,
  },
  styles = {
    comments = { italic = true, },
  },
  plugins = {
    'dap',
    'dashboard',
    'gitsigns',
    'hop',
    'indent-blankline',
    'lspsaga',
    'mini',
    'neogit',
    'nvim-cmp',
    'nvim-navic',
    'nvim-tree',
    'sneak',
    'telescope',
    'trouble',
    'which-key',
  },
  high_visibility = {
    lighter = true,
    darker = true,
  },
  async_loading = true,
  custom_highlights = {
    LspCodeLens = { link = 'DiagnosticHint' }
  },
})
vim.cmd [[colorscheme material]]
