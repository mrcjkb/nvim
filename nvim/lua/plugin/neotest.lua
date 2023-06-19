local neotest = require('neotest')
neotest.setup {
  adapters = {
    require('neotest-haskell') {
      frameworks = {
        {
          framework = 'tasty',
          modules = { 'Test.Tasty', 'T', 'Test.Util', 'TestUtil' },
        },
        'hspec',
        'sydtest',
      },
    },
    require('neotest-python') {
      dap = { justMyCode = false },
    },
    require('neotest-plenary'),
    require('neotest-rust'),
    -- require("neotest-vim-test")({
    --   ignore_file_types = { "haskell", "python", "vim", "lua", "rust" },
    -- }),
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
local opts = { noremap = true }
vim.keymap.set('n', '<leader>nr', function()
  neotest.run.run()
end, opts)
vim.keymap.set('n', '<leader>nf', function()
  neotest.run.run(vim.api.nvim_buf_get_name(0))
end, opts)
vim.keymap.set('n', '<leader>no', function()
  neotest.output.open()
end, opts)
vim.keymap.set('n', '<leader>ns', function()
  neotest.summary.toggle()
end, opts)
