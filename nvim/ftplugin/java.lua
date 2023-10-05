local lsp = require('mrcjk.lsp')
local jdtls = require('jdtls')

local on_jdtls_attach = function(client, bufnr)
  lsp.on_attach(client, bufnr)
  -- With `hotcodereplace = 'auto' the debug adapter will try to apply code changes
  -- you make during a debug session immediately.
  -- You can use the `JdtHotcodeReplace` command to trigger it manually
  -- jdtls.setup_dap {
  --   hotcodereplace = 'auto',
  -- }
  local function desc(description)
    return { noremap = true, silent = true, desc = description }
  end
  vim.keymap.set('n', '<A-o>', jdtls.organize_imports, desc('[lsp] organize imports'))
  vim.keymap.set('n', '<A-v>', jdtls.extract_variable, desc('[lsp] extract variable'))
  vim.keymap.set('v', '<A-v>', function()
    jdtls.extract_variable { visual = true }
  end, desc('[lsp] extract variable (visual)'))
  vim.keymap.set('v', '<A-m>', function()
    jdtls.extract_method { visual = true }
  end, desc('[lsp] extract method (visual)'))
  -- nvim-dap (requires java-debug and vscode-java-test bundles)
  -- vim.keymap.set('n', '<leader>df', jdtls.test_class, opts)
  -- vim.keymap.set('n', '<leader>dn', jdtls.test_nearest_method, opts)
end

local cmd = { 'jdt-language-server' }

if vim.fn.executable(cmd[1]) ~= 1 then
  return
end

local java_runtime_dir = os.getenv('JAVA_RUNTIME_DIR')

local settings = {
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
    configuration = {
      runtimes = java_runtime_dir and {
        {
          name = 'Java',
          path = java_runtime_dir,
          -- path = '/usr/lib/jvm/java-8-openjdk/',
        } or nil,
      },
    },
  },
}

jdtls.start_or_attach {
  capabilities = lsp.capabilities,
  cmd = cmd,
  settings = settings,
  on_attach = on_jdtls_attach,
  on_init = function(client, _)
    client.notify('workspace/didChangeConfiguration', { settings = settings })
  end,
}
