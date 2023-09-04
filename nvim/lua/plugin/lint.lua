local lint = require('lint')
local hlint_hint_file = os.getenv('HLINT_HINT')

local function if_has_exe(cmd)
  return vim.fn.executable(cmd) == 1 and { cmd }
end

if hlint_hint_file and hlint_hint_file ~= '' then
  lint.linters.hlint.args = { '--json', '--no-exit-code', '--hint=' .. hlint_hint_file }
end
lint.linters_by_ft = {
  haskell = if_has_exe('hlint'),
  markdown = if_has_exe('markdownlint'),
  lua = if_has_exe('luacheck'),
}
vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('lint-commands', {}),
  pattern = {
    '*.hs',
    '*.md',
    '*.lua',
  },
  callback = function()
    for _, client in pairs(vim.lsp.get_clients()) do
      if vim.startswith(client.name, 'haskell-tools') then
        return
      end
    end
    pcall(lint.try_lint)
  end,
})
