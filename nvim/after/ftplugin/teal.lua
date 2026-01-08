local files = require('mrcjk.files')
files.treesitter_start()

local root_files = {
  'tlconfig.lua',
}
local root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1])

local teal_ls_cmd = 'teal-language-server'


if root_dir and vim.fn.executable(teal_ls_cmd) == 1 then
  local lsp = require('mrcjk.lsp')

  ---@diagnostic disable-next-line: missing-fields
  vim.lsp.start {
    name = 'teal-language-server',
    cmd = { teal_ls_cmd },
    capabilities = lsp.capabilities,
    root_dir = root_dir
  }
end
