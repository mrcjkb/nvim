vim.g.material_style = 'darker'
vim.g.material_terminal_italics = 1

require('material').setup {
  contrast = {
    terminal = true,
    floating_windows = false,
    cursor_line = true,
    non_current_windows = true,
  },
  styles = {
    comments = { italic = true },
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
  disable = {
    colored_cursor = true,
  },
  high_visibility = {
    lighter = true,
    darker = true,
  },
  async_loading = true,
  custom_highlights = {
    LspCodeLens = { link = 'DiagnosticHint', italic = true },
    TermCursor = { link = 'Cursor' },
    TermCursorNC = { bg = 'red', fg = 'white', ctermbg = 1, ctermfg = 15 },
    FidgetTitle = { link = 'DiagnosticHint' },
    IlluminatedWordRead = { link = 'TSDefinitionUsage' },
    IlluminatedWordWrite = { link = 'TSDefinitionUsage' },
    IlluminatedWordText = { link = 'TSDefinitionUsage' },
    NeotestPassed = { fg = '#ABCF76' },
    NeotestFailed = { link = 'DiagnosticError' },
    NeotestRunning = { link = 'DiagnosticWarn' },
    NeotestTarget = { link = 'DiagnosticError' },
    NeotestAdapterName = { link = 'DiagnosticHint' },
    NeotestDir = { link = 'DiagnosticHint' },
    NeotestFile = { link = 'DiagnosticHint' },
    NeotestSkipped = { link = 'DiagnosticHint' },
  },
  custom_colors = function(colors)
    colors.editor.fg = '#FFFFFF'
    colors.editor.fg_dark = colors.main.white
    colors.editor.accent = colors.main.darkpurple
  end,
}
vim.cmd.colorscheme('material')
