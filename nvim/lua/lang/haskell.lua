local ht = require('haskell-tools')
local telescope = require('telescope')
local lsp = require('mrcjk.lsp')
local keymap_opts = { noremap = true, silent = true }

local haskell = {}

function haskell.start_or_attach()
  ht.start_or_attach {
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

        if ht.dap then
          ht.dap.add_configurations(bufnr)
        end
      end,
      default_settings = {
        haskell = {
          formattingProvider = 'stylish-haskell',
          maxCompletions = 10,
        },
      },
    },
  }
  vim.keymap.set('n', '<space>gp', ht.project.telescope_package_grep, keymap_opts)
  vim.keymap.set('n', '<space>gf', ht.project.telescope_package_files, keymap_opts)
end

return haskell
