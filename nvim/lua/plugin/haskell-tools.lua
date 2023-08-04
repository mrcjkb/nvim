local keymap_opts = { noremap = true, silent = true }
local telescope = require('telescope')
local lsp = require('mrcjk.lsp')

vim.g.haskell_tools = {
  tools = {
    repl = {
      handler = 'toggleterm',
      auto_focus = false,
    },
    codeLens = {
      autoRefresh = false,
    },
    definition = {
      hoogle_signature_fallback = true,
    },
  },
  hls = {
    on_attach = function(client, bufnr, ht)
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
    capabilities = lsp.capabilities,
    default_settings = {
      haskell = {
        formattingProvider = 'stylish-haskell',
        maxCompletions = 10,
      },
    },
  },
}
