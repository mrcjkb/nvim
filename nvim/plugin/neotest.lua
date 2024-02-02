local function desc(description)
  return { noremap = true, silent = true, desc = description }
end

local neotest = require('neotest')

---Neotest is quite heavy on startup, so this initializes it lazily, on keymap
---@diagnostic disable-next-line: missing-fields
neotest.setup {
  adapters = {
    require('neotest-haskell') {
      frameworks = {
        {
          framework = 'tasty',
          modules = { 'Test.Tasty', 'Tiko' },
        },
        'hspec',
        'sydtest',
      },
    },
    require('rustaceanvim.neotest'),
    require('neotest-java'),
  },
  icons = {
    failed = '',
    passed = '',
    running = '',
    skipped = '',
    unknown = '',
  },
  quickfix = {
    enabled = false,
    open = false,
  },
}
vim.keymap.set('n', '<leader>nr', neotest.run.run, desc('[test] run nearest'))
vim.keymap.set('n', '<leader>nf', function()
  neotest.run.run(vim.api.nvim_buf_get_name(0))
end, desc('[test] run file'))
vim.keymap.set('n', '<leader>nw', function()
  neotest.watch.watch(vim.api.nvim_buf_get_name(0))
end, desc('[test] watch file'))
vim.keymap.set('n', '<leader>no', neotest.output.open, desc('[test] open output'))
vim.keymap.set('n', '<leader>ns', neotest.summary.toggle, desc('[test] toggle summary'))
