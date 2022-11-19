local api = vim.api

local tempdirgroup = api.nvim_create_augroup('tempdir', { clear = true })
-- Do not set undofile for files in /tmp
api.nvim_create_autocmd('BufWritePre', {
  pattern = '/tmp/*',
  group = tempdirgroup,
  callback = function()
    vim.cmd('setlocal noundofile')
  end,
})

vim.api.nvim_create_autocmd('ColorScheme', {
  -- Add quick-scope highlights on color scheme switch
  -- (has to be created before setting the color scheme)
  group = vim.api.nvim_create_augroup('qs_colors', {}),
  callback = function()
    vim.api.nvim_set_hl(
      0,
      'QuickScopePrimary',
      { fg = '#AFFF5F', underline = true, ctermfg = 155, cterm = { underline = true } }
    )
    vim.api.nvim_set_hl(
      0,
      'QuickScopeSecondary',
      { fg = '#AFFF5F', underline = true, ctermfg = 155, cterm = { underline = true } }
    )
  end,
})
