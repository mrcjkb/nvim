local bufnr = vim.api.nvim_get_current_buf()
if vim.b[bufnr].mrcjkb_did_ftplugin then
  return
end
vim.b[bufnr].mrcjkb_did_ftplugin = true

local lsp = require('mrcjk.lsp')

if vim.fn.executable('nil') ~= 1 then
  return
end

vim.lsp.start {
  name = 'nil_ls',
  cmd = { 'nil' },
  root_dir = vim.fs.dirname(vim.fs.find({ 'flake.nix', '.git' }, { upward = true })[1]),
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
  settings = {
    formatting = {
      command = { 'alejandra', '-qq' },
    },
    flake = {
      autoArchive = true,
      autoEvalInputs = true,
    },
  },
}

vim.api.nvim_set_hl(0, '@lsp.type.property.nix', {})
vim.api.nvim_set_hl(0, '@lsp.type.variable.nix', {})
