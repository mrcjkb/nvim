local lspconfig = require('lspconfig')
local lsp = require('vim.lsp')
local api = vim.api

local on_attach = function(client, bufnr)
  api.nvim_command("setlocal signcolumn=yes")

  local function buf_set_keymap(...) api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) api.nvim_buf_set_option(bufnr, ...) end
  local function buf_set_var(...) api.nvim_buf_set_var(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  buf_set_option("bufhidden", "hide")
  buf_set_var("lsp_client_id", client.id)

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>o', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
  buf_set_keymap('n', '<space>d', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  buf_set_keymap('n', '<a-cr>', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '[e', '<cmd>lua vim.lsp.diagnostic.goto_prev({ severity=\'Error\' })<CR>', opts)
  buf_set_keymap('n', ']e', '<cmd>lua vim.lsp.diagnostic.goto_next({ severity=\'Error\' })<CR>', opts)
  buf_set_keymap('n', '[w', '<cmd>lua vim.lsp.diagnostic.goto_prev({ severity=\'Warning\' })<CR>', opts)
  buf_set_keymap('n', ']w', '<cmd>lua vim.lsp.diagnostic.goto_next({ severity=\'Warning\' })<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist({ open_loclist=false })<CR>', opts)
  buf_set_keymap('n', '<space>c', '<cmd>lua require\'lsp-ext\'.diagnostics_set_qflist({ open_qflist=false })<CR>', opts)
  buf_set_keymap('n', '<space>w', '<cmd>lua require\'lsp-ext\'.diagnostics_set_qflist({ open_qflist=false, severity=\'Warning\' })<CR>', opts)
  buf_set_keymap('n', '<space>i', '<cmd>lua require\'lsp-ext\'.diagnostics_set_qflist({ open_qflist=false, severity=\'Information\' })<CR>', opts)
  buf_set_keymap('n', '<F5>', '<Cmd>lua require\'dap\'.stop()<CR>', opts)
  buf_set_keymap('n', '<F6>', '<Cmd>lua require\'dap\'.step_out()<CR>', opts)
  buf_set_keymap('n', '<F7>', '<Cmd>lua require\'dap\'.step_into()<CR>', opts)
  buf_set_keymap('n', '<F8>', '<Cmd>lua require\'dap\'.step_over()<CR>', opts)
  buf_set_keymap('n', '<F9>', '<Cmd>lua require\'dap\'.continue()<CR>', opts)
  buf_set_keymap('n', '<leader>b', '<Cmd>lua require\'dap\'.toggle_breakpoint()<CR>', opts)
  buf_set_keymap('n', '<leader>B', '<Cmd>lua require\'dap-setup\'.toggle_conditional_breakpoint()<CR>', opts)
  buf_set_keymap('n', '<leader>dr', '<Cmd>lua require\'dap\'.repl.toggle({height=15})<CR>', opts)
  buf_set_keymap('n', '<leader>dl', '<Cmd>lua require\'dap\'.run_last()<CR>', opts)
  buf_set_keymap('n', '<leader>dS', '<Cmd>lua require(\'dap.ui.widgets\').centered_float(require(\'dap.ui.widgets\').frames)<CR>', opts)
  buf_set_keymap('n', '<leader>ds', '<Cmd>lua require(\'dap.ui.widgets\').centered_float(require(\'dap.ui.widgets\').scopes)<CR>', opts)
  buf_set_keymap('n', '<leader>dh', '<Cmd>lua require(\'dap.ui.widgets\').hover()<CR>', opts)
  buf_set_keymap('v', '<leader>dh', '<Cmd>lua require(\'dap.ui.widgets\').hover(require(\'dap.utils\').get_visual_selection_text)<CR>', opts)
  buf_set_keymap('v', '<M-e>', '<Cmd> lua require(\'dapui\').eval()<CR>', opts)
  buf_set_keymap('v', '<M-k>', '<Cmd> lua require(\'dapui\').float_element()<CR>', opts)
  buf_set_keymap('n', '<leader>du', '<Cmd> lua require(\'dapui\').toggle()<CR>', opts)


  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=237 guibg=#45403d
      hi LspReferenceText cterm=bold ctermbg=237 guibg=#45403d
      hi LspReferenceWrite cterm=bold ctermbg=237 guibg=#45403d
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end

  -- Autocomplete signature hints
  require'lsp_signature'.on_attach()
  require('lspkind').init({
      -- preset = 'codicons',
  })
  require('java_tsls').setup_lsp_commands()
end

lspconfig.hls.setup{ on_attach = on_attach }
local on_pyright_attach = function(client, bufnr)
  on_attach(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', '<leader>dn', '<Cmd>lua require\'dap-python\'.test_method()<CR>', opts)
  buf_set_keymap('n', '<leader>df', '<Cmd>lua require\'dap-python\'.test_class()<CR>', opts)
  buf_set_keymap('v', '<leader>ds', '<Cmd>lua require\'dap-python\'.debug_selection()<CR>', opts)
end
lspconfig.pyright.setup{ on_attach = on_pyright_attach }
lspconfig.tsserver.setup{ on_attach = on_attach }
-- lspconfig.kotlin_language_server.setup{ on_attach = on_attach }
local on_latex_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  buf_set_keymap('n', '<space>b', '<cmd>te pdflatex -file-line-error -halt-on-error %<CR>', { noremap=true, silent=true })
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
  on_attach = on_latex_attach
}
lspconfig.dockerls.setup{ on_attach = on_attach }
lspconfig.cmake.setup{ on_attach = on_attach }
lspconfig.gopls.setup{ on_attach = on_attach }
lspconfig.vimls.setup{ on_attach = on_attach }

local sumneko_root_path = os.getenv("HOME") .. '/git/clones/lua-language-server'
local sumneko_binary = sumneko_root_path.."/bin/Linux/lua-language-server"
local luadev = require("lua-dev").setup({
  lspconfig = {
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
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
  }
})
-- lspconfig.sumneko_lua.setup(luadev)
require('nlua.lsp.nvim').setup(lspconfig, {
  on_attach = on_attach,
})

local rust_tools_opts = {
    tools = { -- rust-tools options
        autoSetHints = true,
        -- whether to show hover actions inside the hover window
        -- this overrides the default hover handler so something like lspsaga.nvim's hover would be overriden by this
        -- default: true
        hover_with_actions = true,
        runnables = {
            use_telescope = false
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
require('rust-tools').setup(rust_tools_opts)
lspconfig.rust_analyzer.setup { on_attach = on_attach }

-- jdt.ls
-- `code_action` is a superset of vim.lsp.buf.code_action and you'll be able to
-- use this mapping also with other language servers
local jdtls = require('jdtls')
local on_jdtls_attach = function(client, bufnr)
  on_attach(client, bufnr)
  jdtls.setup_dap({
      hotcodereplace = 'auto'
    })
  jdtls.setup.add_commands()
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap=true, silent=true}
  local jdtls_str = 'lua require(\'jdtls\')'
  buf_set_keymap('n', '<A-CR>', '<cmd>'..jdtls_str..'.code_action()<CR>', opts)
  buf_set_keymap('v', '<A-CR> <Esc>', '<cmd>'..jdtls_str..'.code_action(true)<CR>', opts)
  buf_set_keymap('n', '<leader>r', '<cmd>'..jdtls_str..'.code_action(false, refactor)<CR>', opts)
  buf_set_keymap('n', '<A-o>', '<cmd>'..jdtls_str..'.organize_imports()<CR>', opts)
  buf_set_keymap('n', '<A-v>', '<cmd>'..jdtls_str..'.extract_variable()<CR>', opts)
  buf_set_keymap('v', '<A-v>', '<cmd>'..jdtls_str..'.extract_variable(true)<CR>', opts)
  buf_set_keymap('v', '<A-m>', '<cmd>'..jdtls_str..'.extract_method(true)<CR>', opts)
  -- nvim-dap (requires java-debug and vscode-java-test bundles)
  buf_set_keymap('n', '<leader>df', '<cmd>'..jdtls_str..'.test_class()<CR>', opts)
  buf_set_keymap('n', '<leader>dn', '<cmd>'..jdtls_str..'.test_nearest_method()<CR>', opts)
  require'lsp-status'.register_progress()
end


function setup_jdtls()
  local home = os.getenv('HOME')
  local root_markers = {'gradlew', 'mvnw', '.classpath'}
  local root_dir = require('jdtls.setup').find_root(root_markers)
  local capabilities = lsp.protocol.make_client_capabilities()
  capabilities.workspace.configuration = true
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  local workspace_folder = home .. "/.workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
  local config = {
    flags = {
      allow_incremental_sync = true,
    };
    capabilities = capabilities,
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
      configuration = {
        runtimes = {
          {
            name = "JavaSE-16",
            path = "/usr/lib/jvm/liberica-jdk-full/",
          },
          {
            name = "JavaSE-11",
            path = "/usr/lib/jvm/liberica-jdk-11-full/",
          },
        }
      };
    };
  }
  config.cmd = {'jdtls-init.sh', workspace_folder}
  config.on_attach = on_jdtls_attach
  config.on_init = function(client, _)
    client.notify('workspace/didChangeConfiguration', { settings = config.settings })
  end
  local extendedClientCapabilities = require'jdtls'.extendedClientCapabilities
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
  local bundles = {
    vim.fn.glob(home .. "/git/clones/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar")
  }
  vim.list_extend(bundles, vim.split(vim.fn.glob(home .. "/git/clones/vscode-java-test/server/*.jar"), "\n"))
  config.init_options = {
    extendedClientCapabilities = extendedClientCapabilities;
    bundles = bundles;
  }
  jdtls.start_or_attach(config)
end

vim.api.nvim_exec([[
      augroup jdtls_lsp
      autocmd!
      autocmd FileType java lua setup_jdtls()
      augroup end
      ]], true)

