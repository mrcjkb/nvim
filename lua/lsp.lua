local lspconfig = require('lspconfig')
local lsp = require('vim.lsp')
local api = vim.api
local keymap = vim.keymap
local dap = require('dap')
local dap_widgets = require('dap.ui.widgets')
local dap_utils = require('dap.utils')
local dapui = require('dapui')
local inlayhints = require('inlay-hints')
inlayhints.setup()

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities = require('lsp-selection-range').update_capabilities(capabilities)

local on_attach = function(client, bufnr)
  api.nvim_command('setlocal signcolumn=yes')

  local function buf_set_option(...)
    api.nvim_buf_set_option(bufnr, ...)
  end
  local function buf_set_var(...)
    api.nvim_buf_set_var(bufnr, ...)
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  buf_set_option('bufhidden', 'hide')
  buf_set_var('lsp_client_id', client.id)

  -- Mappings.
  local opts = { noremap = true, silent = true, buffer = bufnr }
  keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
  keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
  keymap.set('n', '<space>wl', function()
    vim.pretty_print(lsp.buf.list_workspace_folders())
  end, opts)
  keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
  keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
  keymap.set('n', '<space>o', vim.lsp.buf.workspace_symbol, opts)
  keymap.set('n', '<space>d', vim.lsp.buf.document_symbol, opts)
  keymap.set('n', '<M-CR>', vim.lsp.buf.code_action, opts)
  keymap.set('n', '<M-l>', vim.lsp.codelens.run, opts)
  keymap.set('n', '<space>cr', vim.lsp.codelens.refresh, opts)
  keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  keymap.set('n', '<space>f', function()
    vim.lsp.buf.format { async = true }
  end, opts)
  keymap.set('n', 'vv', function()
    require('lsp-selection-range').trigger()
  end, opts)
  keymap.set('v', 'vv', function()
    require('lsp-selection-range').expand()
  end, opts)

  -- Autocomplete signature hints
  require('lsp_signature').on_attach()
  inlayhints.on_attach(client, bufnr)
end

local on_dap_attach = function(bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  keymap.set('n', '<F5>', dap.stop, opts)
  keymap.set('n', '<F6>', dap.step_out, opts)
  keymap.set('n', '<F7>', dap.step_into, opts)
  keymap.set('n', '<F8>', dap.step_over, opts)
  keymap.set('n', '<F9>', dap.continue, opts)
  keymap.set('n', '<leader>b', dap.toggle_breakpoint, opts)
  -- keymap.set('n', '<leader>B', dap.toggle_conditional_breakpoint, opts) -- FIXME
  keymap.set('n', '<leader>dr', function()
    dap.repl.toggle { height = 15 }
  end, opts)
  keymap.set('n', '<leader>dl', dap.run_last, opts)
  keymap.set('n', '<leader>dS', function()
    dap_widgets.centered_float(dap_widgets.frames)
  end, opts)
  keymap.set('n', '<leader>ds', function()
    dap_widgets.centered_float(dap_widgets.scopes)
  end, opts)
  keymap.set('n', '<leader>dh', dap_widgets.hover, opts)
  keymap.set('v', '<leader>dH', function()
    dap_widgets.hover(dap_utils.get_visual_selection_text)
  end, opts)
  keymap.set('v', '<M-e>', dapui.eval, opts)
  keymap.set('v', '<M-k>', dapui.float_element, opts)
  keymap.set('n', '<leader>du', dapui.toggle, opts)
end

local ht = require('haskell-tools')
local def_opts = { noremap = true, silent = true }
ht.setup {
  hls = {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      on_dap_attach(bufnr)
      local opts = vim.tbl_extend('keep', def_opts, { buffer = bufnr })
      keymap.set('n', '<space>hs', ht.hoogle.hoogle_signature, opts)
    end,
    settings = {
      haskell = {
        formattingProvider = 'stylish-haskell',
        maxCompletions = 10,
      },
    },
  },
}
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'haskell',
  group = vim.api.nvim_create_augroup('haskell-keymaps', {}),
  callback = function(meta)
    local bufnr = meta and meta.buf or vim.api.nvim_get_current_buf()
    local opts = vim.tbl_extend('keep', def_opts, { buffer = bufnr })
    keymap.set('n', '<leader>rr', ht.repl.toggle, opts)
    keymap.set('n', '<leader>rl', ht.repl.reload, opts)
    keymap.set('n', '<leader>rf', function()
      ht.repl.toggle(vim.api.nvim_buf_get_name(0))
    end, opts)
    keymap.set('n', '<leader>rq', ht.repl.quit, opts)
    keymap.set('n', '<leader>rp', ht.repl.paste, opts)
    keymap.set('n', '<leader>rt', ht.repl.paste_type, opts)
    keymap.set('n', '<leader>rw', ht.repl.cword_type, opts)
    keymap.set('n', '<space>gp', ht.project.telescope_package_grep, opts)
    keymap.set('n', '<space>gf', ht.project.telescope_package_files, opts)
    -- TODO: remove when ambiguous target issue is resolved
    keymap.set('n', '<leader>tt', '<cmd>TermExec cmd="cabal v2-repl %"<CR>', opts)
  end,
})

-- local dap_python = require('dap-python')
local on_pyright_attach = function(client, bufnr)
  on_attach(client, bufnr)
  on_dap_attach(bufnr)
  -- local opts = { noremap=true, silent=true }
  -- vim.keymap.set('n', '<leader>dn', dap_python.test_method, opts)
  -- vim.keymap.set('n', '<leader>df', dap_python.test_class, opts)
  -- vim.keymap.set('v', '<leader>ds', dap_python.debug_selection, opts)
end
lspconfig.pyright.setup {
  on_attach = on_pyright_attach,
  capabilities = capabilities,
}
-- lspconfig.tsserver.setup{ on_attach = on_attach }
lspconfig.nil_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}
-- lspconfig.kotlin_language_server.setup{ on_attach = on_attach }
local on_latex_attach = function(client, bufnr)
  vim.keymap.set(
    'n',
    '<space>b',
    '<cmd>te pdflatex -file-line-error -halt-on-error %<CR>',
    { noremap = true, silent = true }
  )
  on_attach(client, bufnr)
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
  capabilities = capabilities,
}
-- lspconfig.dockerls.setup{ on_attach = on_attach }
-- lspconfig.cmake.setup{ on_attach = on_attach }
-- lspconfig.gopls.setup{ on_attach = on_attach }
lspconfig.vimls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
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
  on_attach = on_attach,
  capabilities = capabilities,
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
  on_attach(client, bufnr)
  -- Hover actions
  vim.keymap.set('n', '<C-space>', rust_tools.hover_actions.hover_actions, { buffer = bufnr })
  -- Code action groups
  vim.keymap.set('n', '<Leader>a', rust_tools.code_action_group.code_action_group, { buffer = bufnr })
end
lspconfig.rust_analyzer.setup {
  on_attach = rust_analyzer_on_attach,
  capabilities = capabilities,
}

-- jdt.ls
-- `code_action` is a superset of vim.lsp.buf.code_action and you'll be able to
-- use this mapping also with other language servers
local jdtls = require('jdtls')
local on_jdtls_attach = function(client, bufnr)
  on_attach(client, bufnr)
  on_dap_attach(bufnr)
  jdtls.setup_dap {
    hotcodereplace = 'auto',
  }
  jdtls.setup.add_commands()
  local opts = { noremap = true, silent = true }
  vim.keymap.set('n', '<A-o>', jdtls.organize_imports, opts)
  vim.keymap.set('n', '<A-v>', jdtls.extract_variable, opts)
  vim.keymap.set('v', '<A-v>', function()
    jdtls.extract_variable(true)
  end, opts)
  vim.keymap.set('v', '<A-m>', function()
    jdtls.extract_method(true)
  end, opts)
  -- nvim-dap (requires java-debug and vscode-java-test bundles)
  vim.keymap.set('n', '<leader>df', jdtls.test_class, opts)
  vim.keymap.set('n', '<leader>dn', jdtls.test_nearest_method, opts)
  require('lsp-status').register_progress()
end

function Setup_jdtls()
  local root_markers = { 'gradlew', 'mvnw', '.classpath' }
  local root_dir = require('jdtls.setup').find_root(root_markers)
  local jdtls_capabilities = vim.tbl_deep_extend('force', capabilities, {
    workspace = {
      configuration = true,
      textDocument = {
        completion = {
          completionItem = {
            snippetSupport = true,
          },
        },
      },
    },
  })
  local workspace_folder = vim.fn.stdpath('data') .. '/.workspace/' .. vim.fn.fnamemodify(root_dir, ':p:h:t')
  local config = {
    flags = {
      allow_incremental_sync = true,
    },
    capabilities = jdtls_capabilities,
  }
  config.settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = 'fernflower' },
      completion = {
        favoriteStaticMembers = {
          'org.junit.jupiter.api.Assertions.*',
          'org.mockito.Mockito.*',
          'io.vavr.API.$',
          'io.vavr.API.Case',
          'io.vavr.API.Match',
          'io.vavr.API.For',
          'io.vavr.Predicates.not',
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
        },
      },
    },
  }
  config.cmd = { 'jdt-language-server', workspace_folder }
  config.on_attach = on_jdtls_attach
  config.on_init = function(client, _)
    client.notify('workspace/didChangeConfiguration', { settings = config.settings })
  end
  jdtls.start_or_attach(config)
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'java',
  group = vim.api.nvim_create_augroup('jdtls_lsp', {}),
  callback = function()
    Setup_jdtls()
  end,
})

-- json-language-server

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.avsc',
  group = vim.api.nvim_create_augroup('avro-filetype-detection', {}),
  callback = function()
    vim.cmd('setf avro')
  end,
})

lspconfig.jsonls.setup {
  on_attach = on_attach,
  filetypes = { 'json', 'jsonc', 'avro' },
  cmd = { 'json-languageserver', '--stdio' },
}

-- nvim-dap-virtual-text plugin
-- require'nvim-dap-virtual-text'.setup()

-- require('idris2').setup({server = {on_attach = on_attach}})
