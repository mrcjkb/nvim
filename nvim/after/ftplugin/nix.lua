local files = require('mrcjk.files')
files.treesitter_start()

local lsp = require('mrcjk.lsp')

local bufnr = vim.api.nvim_get_current_buf()

if vim.fn.executable('pre-commit') == 1 then
  vim.keymap.set('n', '<leader>pf', function()
    vim.system({ 'pre-commit', 'run', '--file', vim.api.nvim_buf_get_name(bufnr), 'alejandra' }, nil, function()
      vim.schedule(function()
        vim.cmd.checktime()
      end)
    end)
  end)
end


if vim.fn.executable('nixd') == 1 then
  vim.lsp.start {
    name = 'nixd',
    cmd = { 'nixd' },
    root_dir = vim.fs.dirname(vim.fs.find({ 'flake.nix', '.git' }, { upward = true })[1]),
    capabilities = lsp.capabilities,
  }
elseif vim.fn.executable('nil') == 1 then
  ---@diagnostic disable-next-line: missing-fields
  vim.lsp.start {
    name = 'nil_ls',
    cmd = { 'nil' },
    root_dir = vim.fs.dirname(vim.fs.find({ 'flake.nix', '.git' }, { upward = true })[1]),
    capabilities = lsp.capabilities,
    filetypes = { 'nix' },
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
end

vim.api.nvim_set_hl(0, '@lsp.type.property.nix', {})
vim.api.nvim_set_hl(0, '@lsp.type.variable.nix', {})
