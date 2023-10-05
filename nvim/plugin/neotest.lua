local function desc(description)
  return { noremap = true, silent = true, desc = description }
end

---Neotest is quite heavy on startup, so this initializes it lazily, on keymap
local function init(fun)
  local neotest = require('neotest')
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
      require('neotest-rust'),
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
  vim.keymap.del('n', '<leader>nr', desc('[test] run nearest'))
  vim.keymap.set('n', '<leader>nr', neotest.run.run, desc('[test] run nearest'))
  vim.keymap.del('n', '<leader>nf', desc('[test] run file'))
  vim.keymap.set('n', '<leader>nf', function()
    neotest.run.run(vim.api.nvim_buf_get_name(0))
  end, desc('[test] run file'))
  vim.keymap.set('n', '<leader>no', neotest.output.open, desc('[test] open output'))
  vim.keymap.set('n', '<leader>ns', neotest.summary.toggle, desc('[test] toggle summary'))
  fun()
end

vim.keymap.set('n', '<leader>nr', function()
  init(function()
    require('neotest').run.run()
  end)
end, desc('[test] run nearest'))
vim.keymap.set('n', '<leader>nf', function()
  init(function()
    require('neotest').run.run(vim.api.nvim_buf_get_name(0))
  end)
end, desc('[test] run file'))
