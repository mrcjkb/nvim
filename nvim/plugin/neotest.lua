local keymap_opts = { noremap = true, silent = true }

---Neotest is quite heavy on startup, so this initializes it lazily, on keymap
local function init(fun)
  local neotest = require('neotest')
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
  vim.keymap.del('n', '<leader>nr', keymap_opts)
  vim.keymap.set('n', '<leader>nr', neotest.run.run, keymap_opts)
  vim.keymap.del('n', '<leader>nf', keymap_opts)
  vim.keymap.set('n', '<leader>nf', function()
    neotest.run.run(vim.api.nvim_buf_get_name(0))
  end, keymap_opts)
  vim.keymap.set('n', '<leader>no', neotest.output.open, keymap_opts)
  vim.keymap.set('n', '<leader>ns', neotest.summary.toggle, keymap_opts)
  fun()
end

vim.keymap.set('n', '<leader>nr', function()
  init(function()
    require('neotest').run.run()
  end)
end, keymap_opts)
vim.keymap.set('n', '<leader>nf', function()
  init(function()
    require('neotest').run.run(vim.api.nvim_buf_get_name(0))
  end)
end, keymap_opts)
