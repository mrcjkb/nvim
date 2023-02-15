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

require('neodev').setup {
  override = function(root_dir, library)
    local util = require('neodev.util')
    if util.has_file(root_dir, '/etc/nixos') or util.has_file(root_dir, 'nvim-config') then
      library.enabled = true
      library.plugins = true
    end
  end,
}

-- json-language-server

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.avsc',
  group = vim.api.nvim_create_augroup('avro-filetype-detection', {}),
  callback = function()
    vim.cmd.setf('avro')
  end,
})

lspconfig.jsonls.setup {
  on_attach = lsp.on_attach,
  filetypes = { 'json', 'jsonc', 'avro' },
  cmd = { 'json-languageserver', '--stdio' },
}

-- C/C++ -- TODO: Complete
lspconfig.clangd.setup {
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
}

-- nvim-dap-virtual-text plugin
-- require'nvim-dap-virtual-text'.setup()

-- require('idris2').setup({server = {on_attach = on_attach}})
