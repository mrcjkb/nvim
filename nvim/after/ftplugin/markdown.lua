local files = require('mrcjk.files')
files.treesitter_start()

local pandoc_cmd = 'pandoc'
if vim.fn.executable(pandoc_cmd) == 1 then
  vim.cmd.compiler(pandoc_cmd)
end
