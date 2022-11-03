require('material').setup({
  contrast = {
    terminal = true,
    floating_windows = false,
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
  custom_colors = function(colors)
    colors.editor.fg = "#FFFFFF"
    colors.editor.fg_dark = colors.main.white
    colors.editor.accent = colors.main.darkpurple
  end
})
vim.cmd [[colorscheme material]]
