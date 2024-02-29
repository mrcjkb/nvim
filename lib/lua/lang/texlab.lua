local lsp = require('mrcjk.lsp')

local M = {}

local on_latex_attach = function(client, bufnr)
  vim.keymap.set(
    'n',
    '<space>lb',
    '<cmd>te pdflatex -file-line-error -halt-on-error %<CR>',
    { noremap = true, silent = true, desc = '[l]atex [b]uild' }
  )
  lsp.on_attach(client, bufnr)
end

local root_files = { '.git', '.latexmkrc', '.texlabroot', 'texlabroot', 'Tectonic.toml' }

M.launch = function()
  if vim.fn.executable('texlab') == 1 then
    vim.lsp.start {
      cmd = { 'texlab' },
      filetypes = { 'tex', 'plaintex', 'bib' },
      root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
      on_attach = on_latex_attach,
      capabilities = lsp.capabilities,
      single_file_support = true,
      settings = {
        texlab = {
          rootDirectory = nil,
          build = {
            executable = 'pdflatex',
            args = { '-file-line-error', '-halt-on-error', '%f' },
            onSave = true,
            forwardSearchAfter = false,
          },
          auxDirectory = '.',
          forwardSearch = {
            executable = nil,
            args = {},
          },
          chktex = {
            onOpenAndSave = false,
            onEdit = false,
          },
          diagnosticsDelay = 300,
          latexFormatter = 'latexindent',
          latexindent = {
            ['local'] = nil, -- local is a reserved keyword
            modifyLineBreaks = false,
          },
          bibtexFormatter = 'texlab',
          formatterLineLength = 80,
        },
      },
    }
  end
end

return M
