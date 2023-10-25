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
    'eyeliner',
    'fidget',
    'flash',
    'gitsigns',
    'harpoon',
    'illuminate',
    'indent-blankline',
    'neogit',
    'neotest',
    'nvim-cmp',
    'nvim-navic',
    'rainbow-delimiters',
    'telescope',
    -- 'dashboard',
    -- 'sneak',
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
    LspCodeLens = { fg = '#B480D6', italic = true },
    TermCursor = { link = 'Cursor' },
    TermCursorNC = { bg = '#FF5370', fg = 'white', ctermbg = 1, ctermfg = 15 },
    FidgetTitle = { link = 'DiagnosticHint' },
    DapUINormal = { link = 'Normal' },
    DapUIScope = { fg = '#E6B455' },
    DapUIType = { fg = '#B480D6' },
    DapUIValue = { link = 'Normal' },
    DapUIModifiedValue = { fg = '#E6B455', bold = true },
    DapUIDecoration = { fg = '#E6B455' },
    DapUIThread = { fg = '#ABCF76' },
    DapUIStoppedThread = { fg = '#71C6E7' },
    DapUIFrameName = { link = 'Normal' },
    DapUISource = { fg = '#B480D6' },
    DapUILineNumber = { fg = '#71C6E7' },
    DapUIEndofBuffer = { link = 'EndofBuffer' },
    TelescopeResultsTitle = { bg = '#E6B455' },
    TelescopePromptTitle = { bg = '#B480D6' },
    TelescopePreviewTitle = { bg = '#ABCF76' },
    ['@field'] = { fg = '#DDDDDD' },
    ['@parameter'] = { fg = '#EEEEEE', italic = true },
    -- ['@function.call'] = { fg = '#82AAFF', italic = true }, -- blue
    ['@function.call'] = { fg = '#B0C9FF' }, -- paleblue
    ['@function.builtin'] = { fg = '#B0C9FF' }, -- paleblue
    ['@comment.documentation'] = { link = '@comment', italic = false },
    ['@lsp.type.interface'] = { fg = '#B480D6', italic = false },
  },
  custom_colors = function(colors)
    colors.editor.fg = '#FFFFFF'
    colors.editor.fg_dark = colors.main.white
    colors.editor.accent = colors.main.darkpurple
  end,
}
vim.cmd.colorscheme('material')
