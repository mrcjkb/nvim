require('neotest').setup({
  adapters = {
    require("neotest-haskell"),
    require("neotest-python")({
      dap = { justMyCode = false },
    }),
    require("neotest-plenary"),
    require("neotest-rust"),
    -- require("neotest-vim-test")({
      --   ignore_file_types = { "haskell", "python", "vim", "lua", "rust" },
      -- }),
    },
  })
  local opts = { noremap = true, }
  vim.keymap.set('n', '<leader>nr', function() require('neotest').run.run() end, opts)
  vim.keymap.set('n', '<leader>no', function() require('neotest').output.open() end, opts)
  vim.keymap.set('n', '<leader>ns', function() require('neotest').summary.toggle() end, opts)
