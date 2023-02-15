local lsp = require('mrcjk.lsp')

local ht = require('haskell-tools')
local telescope = require('telescope')

local keymap_opts = { noremap = true, silent = true }

ht.start_or_attach {
  tools = {
    repl = {
      handler = 'toggleterm',
      auto_focus = false,
    },
    definition = {
      hoogle_signature_fallback = true,
    },
  },
  hls = {
    on_attach = function(client, bufnr)
      lsp.on_attach(client, bufnr)
      lsp.on_dap_attach(bufnr)
      local opts = vim.tbl_extend('keep', keymap_opts, { buffer = bufnr })
      vim.keymap.set('n', 'gh', ht.hoogle.hoogle_signature, opts)
      vim.keymap.set('n', '<space>tg', telescope.extensions.ht.package_grep, opts)
      vim.keymap.set('n', '<space>th', telescope.extensions.ht.package_hsgrep, opts)
      vim.keymap.set('n', '<space>tf', telescope.extensions.ht.package_files, opts)
      vim.keymap.set('n', 'gp', ht.project.open_package_yaml, opts)
      vim.keymap.set('n', '<space>ea', ht.lsp.buf_eval_all, opts)
    end,
    default_settings = {
      haskell = {
        formattingProvider = 'stylish-haskell',
        maxCompletions = 10,
      },
    },
  },
}

local bufnr = vim.api.nvim_get_current_buf()
local opts = vim.tbl_extend('keep', keymap_opts, { buffer = bufnr })
vim.keymap.set('n', '<leader>rr', ht.repl.toggle, opts)
vim.keymap.set('n', '<leader>rl', ht.repl.reload, opts)
vim.keymap.set('n', '<leader>rf', function()
  ht.repl.toggle(vim.api.nvim_buf_get_name(0))
end, opts)
vim.keymap.set('n', '<leader>rq', ht.repl.quit, opts)
vim.keymap.set('n', '<leader>rp', ht.repl.paste, opts)
vim.keymap.set('n', '<leader>rt', ht.repl.paste_type, opts)
vim.keymap.set('n', '<leader>rw', ht.repl.cword_type, opts)
vim.keymap.set('n', '<space>gp', ht.project.telescope_package_grep, opts)
vim.keymap.set('n', '<space>gf', ht.project.telescope_package_files, opts)
-- TODO: remove when ambiguous target issue is resolved
vim.keymap.set('n', '<leader>tt', '<cmd>TermExec cmd="cabal v2-repl %"<CR>', opts)
