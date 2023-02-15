local lspconfig = require('lspconfig')
local lsp = require('mrcjk.lsp')

-- lspconfig.tsserver.setup{ on_attach = on_attach }
lspconfig.nil_ls.setup {
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
}
-- lspconfig.kotlin_language_server.setup{ on_attach = on_attach }
local on_latex_attach = function(client, bufnr)
  vim.keymap.set(
    'n',
    '<space>b',
    '<cmd>te pdflatex -file-line-error -halt-on-error %<CR>',
    { noremap = true, silent = true }
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
}
-- lspconfig.dockerls.setup{ on_attach = on_attach }
-- lspconfig.cmake.setup{ on_attach = on_attach }
-- lspconfig.gopls.setup{ on_attach = on_attach }
lspconfig.vimls.setup {
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
}

-- C/C++ -- TODO: Complete
lspconfig.clangd.setup {
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
}

-- nvim-dap-virtual-text plugin
-- require'nvim-dap-virtual-text'.setup()

-- require('idris2').setup({server = {on_attach = on_attach}})
