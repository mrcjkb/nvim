local files = require('mrcjk.files')
files.treesitter_start()

require('mrcjk.neotest')

local bufnr = vim.api.nvim_get_current_buf()

if vim.fn.executable('pre-commit') == 1 then
  vim.keymap.set('n', '<leader>pf', function()
    vim.system({ 'pre-commit', 'run', '--file', vim.api.nvim_buf_get_name(bufnr), 'java-format' }, nil, function()
      vim.schedule(function()
        vim.cmd.checktime()
      end)
    end)
  end)
end

local jdtls_bin = vim.fn.executable('jdtls') == 1 and 'jdtls'
  or vim.fn.executable('jdt-language-server') == 1 and 'jdt-language-server'

if not jdtls_bin then
  return
end

local lsp = require('mrcjk.lsp')
local jdtls = require('jdtls')

vim.keymap.set('n', '<leader>ot', function()
  vim.cmd.Other('test')
end, { noremap = true, silent = true, desc = '[o]ther: [t]est', buffer = bufnr })

local on_jdtls_attach = function(_, buf)
  -- With `hotcodereplace = 'auto' the debug adapter will try to apply code changes
  -- you make during a debug session immediately.
  -- You can use the `JdtHotcodeReplace` command to trigger it manually
  -- jdtls.setup_dap {
  --   hotcodereplace = 'auto',
  -- }
  local function desc(description)
    return { noremap = true, silent = true, desc = description, buffer = buf }
  end
  vim.keymap.set('n', '<space>oi', jdtls.organize_imports, desc('java: [o]rganize [i]mports'))
  vim.keymap.set('n', '<space>ev', jdtls.extract_variable, desc('java: [e]xtract [v]ariable'))
  vim.keymap.set('v', '<space>ev', function()
    jdtls.extract_variable { visual = true }
  end, desc('java: [e]xtract [v]ariable (visual)'))
  vim.keymap.set('v', '<space>em', function()
    jdtls.extract_method { visual = true }
  end, desc('java: [e]xtract [m]ethod (visual)'))
  -- nvim-dap (requires java-debug and vscode-java-test bundles)
  -- vim.keymap.set('n', '<leader>df', jdtls.test_class, opts)
  -- vim.keymap.set('n', '<leader>dn', jdtls.test_nearest_method, opts)
end

local workspace_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', 'mvnw', '.git' }, { upward = true })[1])

local cmd = { jdtls_bin }

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
        } or nil,
      },
    },
  },
}

jdtls.start_or_attach {
  capabilities = lsp.capabilities,
  cmd = cmd,
  root_dir = workspace_dir,
  settings = settings,
  on_attach = on_jdtls_attach,
  ---@param client vim.lsp.Client
  on_init = function(client, _)
    client:notify(vim.lsp.protocol.Methods.workspace_didChangeConfiguration, { settings = settings })
  end,
}
