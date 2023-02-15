local lspconfig = require('lspconfig')
local lsp = require('mrcjk.lsp')

-- lspconfig.tsserver.setup{ on_attach = on_attach }
lspconfig.nil_ls.setup {
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
}
-- lspconfig.kotlin_language_server.setup{ on_attach = on_attach }
local on_latex_attach = function(client, bufnr)
  vim.keymap.set(
    'n',
    '<space>b',
    '<cmd>te pdflatex -file-line-error -halt-on-error %<CR>',
    { noremap = true, silent = true }
  )
  lsp.on_attach(client, bufnr)
end
lspconfig.texlab.setup {
  settings = {
    latex = {
      build = {
        onSave = true,
      },
    },
  },
  on_attach = on_latex_attach,
  capabilities = lsp.capabilities,
}
-- lspconfig.dockerls.setup{ on_attach = on_attach }
-- lspconfig.cmake.setup{ on_attach = on_attach }
-- lspconfig.gopls.setup{ on_attach = on_attach }
lspconfig.vimls.setup {
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
}

require('neodev').setup {
  override = function(root_dir, library)
    local util = require('neodev.util')
    if util.has_file(root_dir, '/etc/nixos') or util.has_file(root_dir, 'nvim-config') then
      library.enabled = true
      library.plugins = true
    end
  end,
}

lspconfig.sumneko_lua.setup {
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {
          'vim',
          'describe',
          'it',
          'assert',
        },
      },
      -- workspace = {
      --   -- Make the server aware of Neovim runtime files
      -- TODO: Refine to library plugins and neovim API
      --   library = vim.api.nvim_get_runtime_file('', true),
      -- },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

local rust_tools_opts = {
  tools = { -- rust-tools options
    autoSetHints = true,
    runnables = {
      use_telescope = true,
    },
    -- these apply to the default RustSetInlayHints command
    inlay_hints = {
      auto = false, -- provided by inlay-hints plugin
      -- show_parameter_hints = true,
      -- parameter_hints_prefix = ' ← ',
      -- other_hints_prefix = ' ⇒ ',
    },
  },
  -- all the opts to send to nvim-lspconfig
  -- these override the defaults set by rust-tools.nvim
  -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
  server = {}, -- rust-analyer options
}
local rust_tools = require('rust-tools')
rust_tools.setup(rust_tools_opts)
local rust_analyzer_on_attach = function(client, bufnr)
  lsp.on_attach(client, bufnr)
  -- Hover actions
  vim.keymap.set('n', '<C-space>', rust_tools.hover_actions.hover_actions, { buffer = bufnr })
  -- Code action groups
  vim.keymap.set('n', '<Leader>a', rust_tools.code_action_group.code_action_group, { buffer = bufnr })
end
lspconfig.rust_analyzer.setup {
  on_attach = rust_analyzer_on_attach,
  capabilities = lsp.capabilities,
}

-- json-language-server

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.avsc',
  group = vim.api.nvim_create_augroup('avro-filetype-detection', {}),
  callback = function()
    vim.cmd.setf('avro')
  end,
})

lspconfig.jsonls.setup {
  on_attach = lsp.on_attach,
  filetypes = { 'json', 'jsonc', 'avro' },
  cmd = { 'json-languageserver', '--stdio' },
}

-- C/C++ -- TODO: Complete
lspconfig.clangd.setup {
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
}

-- nvim-dap-virtual-text plugin
-- require'nvim-dap-virtual-text'.setup()

-- require('idris2').setup({server = {on_attach = on_attach}})
