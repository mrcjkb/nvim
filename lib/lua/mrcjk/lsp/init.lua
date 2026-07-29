---@diagnostic disable: cast-local-type
local lsp = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.workspace.didChangeWatchedFiles = {
  dynamicRegistration = true,
}

---@type lsp.ClientCapabilities
---@diagnostic disable-next-line: assign-type-mismatch
lsp.capabilities = capabilities

return lsp
