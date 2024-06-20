local M = {}

local root_files = {
  '.clangd',
  '.clang-tidy',
  '.clang-format',
  'compile_commands.json',
  'compile_flags.txt',
  'configure.ac', -- AutoTools
}

function M.launch()
  vim.lsp.start {
    cmd = { 'clangd' },
    root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
    single_file_support = true,
    capabilities = require('mrcjk.lsp').capabilities,
  }
end

return M
