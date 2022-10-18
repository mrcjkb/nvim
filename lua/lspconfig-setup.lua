local lspconfig = require('lspconfig')
local lsp = require('vim.lsp')
local api = vim.api
local keymap = vim.keymap
local dap = require('dap')
local dap_widgets = require('dap.ui.widgets')
local dap_utils = require('dap.utils')
local dapui = require('dapui')

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities(lsp.protocol.make_client_capabilities())

local on_attach = function(client, bufnr)
  api.nvim_command("setlocal signcolumn=yes")

  local function buf_set_option(...) api.nvim_buf_set_option(bufnr, ...) end
  local function buf_set_var(...) api.nvim_buf_set_var(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  buf_set_option("bufhidden", "hide")
  buf_set_var("lsp_client_id", client.id)

  -- Mappings.
  local opts = { noremap=true, silent=true, buffer = bufnr }
  keymap.set('n', 'gD', lsp.buf.declaration, opts)
  keymap.set('n', 'gd', lsp.buf.definition, opts)
  keymap.set('n', 'K', lsp.buf.hover, opts)
  keymap.set('n', 'gi', lsp.buf.implementation, opts)
  keymap.set('n', '<C-k>', lsp.buf.signature_help, opts)
  keymap.set('n', '<space>wa', lsp.buf.add_workspace_folder, opts)
  keymap.set('n', '<space>wr', lsp.buf.remove_workspace_folder, opts)
  keymap.set('n', '<space>wl', function() vim.pretty_print(lsp.buf.list_workspace_folders()) end, opts)
  keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
  keymap.set('n', '<space>rn', lsp.buf.rename, opts)
  keymap.set('n', '<space>o', lsp.buf.workspace_symbol, opts)
  keymap.set('n', '<space>d', lsp.buf.document_symbol, opts)
  keymap.set('n', '<M-CR>', lsp.buf.code_action, opts)
  keymap.set('n', '<C-CR>', lsp.codelens.apply, opts)
  keymap.set('n', '<space>cr', lsp.codelens.refresh, opts)
  keymap.set('n', 'gr', lsp.buf.references, opts)
  keymap.set('n', '<space>f', lsp.buf.formatting, opts)
  keymap.set('v', '<space>f', lsp.buf.range_formatting, opts)

  -- Autocomplete signature hints
  require('lsp_signature').on_attach()
end

local on_dap_attach = function(bufnr)
  local opts = { noremap=true, silent=true, buffer = bufnr }
  keymap.set('n', '<F5>', dap.stop, opts)
  keymap.set('n', '<F6>', dap.step_out, opts)
  keymap.set('n', '<F7>', dap.step_into, opts)
  keymap.set('n', '<F8>', dap.step_over, opts)
  keymap.set('n', '<F9>', dap.continue, opts)
  keymap.set('n', '<leader>b', dap.toggle_breakpoint, opts)
  -- keymap.set('n', '<leader>B', dap.toggle_conditional_breakpoint, opts) -- FIXME
  keymap.set('n', '<leader>dr', function() dap.repl.toggle({height=15}) end, opts)
  keymap.set('n', '<leader>dl', dap.run_last, opts)
  keymap.set('n', '<leader>dS', function() dap_widgets.centered_float(dap_widgets.frames) end, opts)
  keymap.set('n', '<leader>ds', function() dap_widgets.centered_float(dap_widgets.scopes) end, opts)
  keymap.set('n', '<leader>dh', dap_widgets.hover, opts)
  keymap.set('v', '<leader>dH', function() dap_widgets.hover(dap_utils.get_visual_selection_text) end, opts)
  keymap.set('v', '<M-e>', dapui.eval, opts)
  keymap.set('v', '<M-k>', dapui.float_element, opts)
  keymap.set('n', '<leader>du', dapui.toggle, opts)
end

require('haskell-tools').setup {
  hls = {
    on_attach = function (client, bufnr)
      on_attach(client, bufnr)
      on_dap_attach(bufnr)
    end,
    haskell = {
      formattingProvider = 'stylish-haskell',
      checkProject = false,
    },
  },
}

local dap_python = require('dap-python')
local on_pyright_attach = function(client, bufnr)
  on_attach(client, bufnr)
  on_dap_attach(bufnr)
  local opts = { noremap=true, silent=true }
  vim.keymap.set('n', '<leader>dn', dap_python.test_method, opts)
  vim.keymap.set('n', '<leader>df', dap_python.test_class, opts)
  vim.keymap.set('v', '<leader>ds', dap_python.debug_selection, opts)
end
lspconfig.pyright.setup{
  on_attach = on_pyright_attach,
  capabilities = capabilities,
}
-- lspconfig.tsserver.setup{ on_attach = on_attach }
lspconfig.rnix.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}
-- lspconfig.kotlin_language_server.setup{ on_attach = on_attach }
local on_latex_attach = function(client, bufnr)
  vim.keymap.set('n', '<space>b', '<cmd>te pdflatex -file-line-error -halt-on-error %<CR>', { noremap=true, silent=true })
  on_attach(client, bufnr)
end
lspconfig.texlab.setup {
  settings = {
    latex = {
      build = {
        onSave = true;
      }
    }
  },
  on_attach = on_latex_attach,
  capabilities = capabilities,
}
-- lspconfig.dockerls.setup{ on_attach = on_attach }
-- lspconfig.cmake.setup{ on_attach = on_attach }
-- lspconfig.gopls.setup{ on_attach = on_attach }
lspconfig.vimls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
}

require('neodev').setup {
  override = function(root_dir, library)
    if require('neodev.util').has_file(root_dir, "/etc/nixos") then
      library.enabled = true
      library.plugins = true
    end
  end,
}

-- lspconfig.sumneko_lua.setup {}

local sumneko_binary = os.getenv('SUMNEKO_BIN_PATH')
local sumneko_main = os.getenv('SUMNEKO_MAIN_PATH')
require('nlua.lsp.nvim').setup(lspconfig, {
  cmd = sumneko_binary and sumneko_main and { sumneko_binary, '-E', sumneko_main } or { 'lua-language-server' },
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
  on_attach = on_attach,
  capabilities = capabilities,

})

local rust_tools_opts = {
    tools = { -- rust-tools options
        autoSetHints = true,
        runnables = {
            use_telescope = true,
        },
        -- these apply to the default RustSetInlayHints command
        inlay_hints = {
            show_parameter_hints = true,
            parameter_hints_prefix = " ← ",
            other_hints_prefix  = " ⇒ ",
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
  vim.keymap.set("n", "<C-space>", rust_tools.hover_actions.hover_actions, { buffer = bufnr })
  -- Code action groups
  vim.keymap.set("n", "<Leader>a", rust_tools.code_action_group.code_action_group, { buffer = bufnr })
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
  jdtls.setup_dap({
      hotcodereplace = 'auto'
    })
  jdtls.setup.add_commands()
  local opts = { noremap=true, silent=true}
  vim.keymap.set('n', '<A-o>', jdtls.organize_imports, opts)
  vim.keymap.set('n', '<A-v>', jdtls.extract_variable, opts)
  vim.keymap.set('v', '<A-v>', function() jdtls.extract_variable(true) end, opts)
  vim.keymap.set('v', '<A-m>', function() jdtls.extract_method(true) end, opts)
  -- nvim-dap (requires java-debug and vscode-java-test bundles)
  vim.keymap.set('n', '<leader>df', jdtls.test_class, opts)
  vim.keymap.set('n', '<leader>dn', jdtls.test_nearest_method, opts)
  require'lsp-status'.register_progress()
end


local jdtls_capabilities = capabilities
function Setup_jdtls()
  local root_markers = {'gradlew', 'mvnw', '.classpath'}
  local root_dir = require('jdtls.setup').find_root(root_markers)
  jdtls_capabilities.workspace.configuration = true
  jdtls_capabilities.textDocument.completion.completionItem.snippetSupport = true
  local workspace_folder = vim.fn.stdpath('data')..'/.workspace/' .. vim.fn.fnamemodify(root_dir, ":p:h:t")
  local config = {
    flags = {
      allow_incremental_sync = true,
    };
    capabilities = jdtls_capabilities,
  }
  config.settings = {
    java = {
      signatureHelp = { enabled = true };
      contentProvider = { preferred = 'fernflower' };
      completion = {
        favoriteStaticMembers = {
          "java.util.function.Predicate.not",
          "java.util.function.Function.identity",
          "java.util.logging.*",
          "org.junit.jupiter.api.Assertions.*",
          "org.mockito.Mockito.*",
          "io.vavr.API.$",
          "io.vavr.API.Case",
          "io.vavr.API.Match",
          "io.vavr.API.For",
          "io.vavr.Predicates.not",
        }
      };
      sources = {
        organizeImports = {
          starThreshold = 9999;
          staticStarThreshold = 9999;
        };
      };
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
        }
      };
      -- configuration = {
        -- runtimes = {
          -- {
          --   name = "JavaSE-17",
          --   path = "/usr/lib/jvm/liberica-jdk-full/",
          -- },
          -- {
          --   name = "JavaSE-11",
          --   path = "/usr/lib/jvm/liberica-jdk-11-full/",
          -- },
    --     }
    --   };
    };
  }
  config.cmd = {'jdt-language-server', workspace_folder}
  config.on_attach = on_jdtls_attach
  config.on_init = function(client, _)
    client.notify('workspace/didChangeConfiguration', { settings = config.settings })
  end
  -- local extendedClientCapabilities = require'jdtls'.extendedClientCapabilities
  -- extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
  -- local bundles = {
  --   vim.fn.glob(home .. "/git/clones/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar")
  -- }
  -- vim.list_extend(bundles, vim.split(vim.fn.glob(home .. "/git/clones/vscode-java-test/server/*.jar"), "\n"))
  -- config.init_options = {
    -- extendedClientCapabilities = extendedClientCapabilities;
    -- bundles = bundles;
  -- }
  jdtls.start_or_attach(config)
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'java',
  group = vim.api.nvim_create_augroup("jdtls_lsp", {}),
  callback = function()
    Setup_jdtls()
  end
})

-- json-language-server

vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead', }, {
  pattern = '*.avsc',
  group = vim.api.nvim_create_augroup("avro-filetype-detection", {}),
  callback = function()
    vim.cmd 'setf avro'
  end
})

lspconfig.jsonls.setup {
  on_attach = on_attach,
  filetypes = { 'json', 'jsonc', 'avro', },
  cmd = { 'json-languageserver', '--stdio', },
}

-- nvim-dap-virtual-text plugin
-- require'nvim-dap-virtual-text'.setup()

-- require('idris2').setup({server = {on_attach = on_attach}})
