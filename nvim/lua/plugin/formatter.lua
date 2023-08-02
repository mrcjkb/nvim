local stylish_config = os.getenv('STYLISH_HASKELL_CONFIG')
local stylish_haskell = require('formatter.filetypes.haskell').stylish_haskell()
require('formatter').setup {
  filetype = {
    haskell = stylish_config and {
      function()
        return vim.tbl_extend('force', stylish_haskell, {
          args = {
            '-c',
            stylish_config,
          },
        })
      end,
    },
    lua = vim.fn.executable('stylua') == 1 and {
      -- "formatter.filetypes.lua" defines default configurations for the
      -- "lua" filetype
      require('formatter.filetypes.lua').stylua,
    } or {},
  },
}
local pattern = { '*.lua' }
if stylish_config then
  table.insert(pattern, '*.hs')
end
vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('post-write-format', {}),
  pattern = pattern,
  command = 'Format',
})
