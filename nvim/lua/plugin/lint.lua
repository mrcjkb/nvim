local lint = require('lint')
local hlint_hint_file = os.getenv('HLINT_HINT')
if hlint_hint_file and hlint_hint_file ~= '' then
  lint.linters.hlint.args = { '--json', '--no-exit-code', '--hint=' .. hlint_hint_file }
end
lint.linters_by_ft = {
  haskell = { 'hlint' },
}
vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('lint-commands', {}),
  pattern = { '*.hs' },
  callback = function()
    require('lint').try_lint()
  end,
})
