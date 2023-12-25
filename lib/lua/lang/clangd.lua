local lspconfig = require('lspconfig')
local lsp = require('mrcjk.lsp')

local M = {}

-- C/C++ -- TODO: Complete
lspconfig.clangd.setup {
  autostart = false,
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
}

M.launch = function()
  if vim.fn.executable('clangd') then
    require('lspconfig.configs').clangd.launch()
  end
end

return M
