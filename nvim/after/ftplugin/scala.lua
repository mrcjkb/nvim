if vim.fn.executable('metals') ~= 1 then
  return
end
local metals = require('metals')
local lsp = require('mrcjk.lsp')
local config = metals.bare_config()
config.settings = {
  metals = {
    useGlobalExecutable = true,
  },
}
config.capabilities = vim.tbl_deep_extend('force', config.capabilities or {}, lsp.capabilities)
metals.initialize_or_attach(config)
