local files = require('mrcjk.files')
files.treesitter_start()

local pandoc_cmd = 'pandoc'
if vim.fn.executable(pandoc_cmd) == 1 then
  if vim.fn.executable('tectonic') == 1 then
    vim.b.pandoc_compiler_args = '--pdf-backend tectonic'
  end
  vim.cmd.compiler(pandoc_cmd)
end
