local lspconfig = require('lspconfig')
local lsp = require('mrcjk.lsp')

local M = {}

local on_latex_attach = function(client, bufnr)
  vim.keymap.set(
    'n',
    '<space>lb',
    '<cmd>te pdflatex -file-line-error -halt-on-error %<CR>',
    { noremap = true, silent = true, desc = 'latex build' }
  )
  lsp.on_attach(client, bufnr)
end
lspconfig.texlab.setup {
  settings = {
    latex = {
      build = {
        onSave = true,
      },
    },
  },
  on_attach = on_latex_attach,
  capabilities = lsp.capabilities,
  autostart = false,
}

M.launch = function()
  if vim.fn.executable('texlab') == 1 then
    require('lspconfig.configs').texlab.launch()
  end
end

return M
