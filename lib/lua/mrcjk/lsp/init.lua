---@diagnostic disable: cast-local-type
local lsp = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()

-- foldingRange capabilities provided by the nvim-ufo plugin
---@diagnostic disable-next-line: inject-field
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

---@type lsp.ClientCapabilities
---@diagnostic disable-next-line: assign-type-mismatch
lsp.capabilities = capabilities

return lsp
