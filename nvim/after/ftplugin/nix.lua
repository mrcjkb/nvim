local lsp = require('mrcjk.lsp')

if vim.fn.executable('nil') ~= 1 then
  return
end

---@diagnostic disable-next-line: missing-fields
vim.lsp.start {
  name = 'nil_ls',
  cmd = { 'nil' },
  root_dir = vim.fs.dirname(vim.fs.find({ 'flake.nix', '.git' }, { upward = true })[1]),
  capabilities = lsp.capabilities,
  settings = {
    ['nil'] = {
      formatting = {
        command = vim.fn.executable('alejandra') == 1 and { 'alejandra', '-qq' }
          or vim.fn.executable('nixpkgs-fmt') == 1 and { 'nixpkgs-fmt' }
          or nil,
      },
      flake = {
        autoArchive = true,
        autoEvalInputs = true,
      },
    },
  },
}

vim.api.nvim_set_hl(0, '@lsp.type.property.nix', {})
vim.api.nvim_set_hl(0, '@lsp.type.variable.nix', {})
