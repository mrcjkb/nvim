local files = require('mrcjk.files')
files.treesitter_start()

require('mrcjk.neotest')
local bufnr = vim.api.nvim_get_current_buf()

vim.bo[bufnr].comments = ':---,:--'

local lsp = require('mrcjk.lsp')

local root_files = {
  '.git',
  '.luarc.json',
  '.luarc.jsonc',
  '.luacheckrc',
  '.stylua.toml',
  'stylua.toml',
  'selene.toml',
  'selene.yml',
}

local lua_ls_cmd = 'lua-language-server'

if vim.fn.executable('pre-commit') == 1 then
  vim.keymap.set('n', '<leader>pf', function()
    vim.system({ 'pre-commit', 'run', '--file', vim.api.nvim_buf_get_name(bufnr), 'stylua' }, nil, function()
      vim.schedule(function()
        vim.cmd.checktime()
      end)
    end)
  end)
end

if vim.fn.executable(lua_ls_cmd) ~= 1 then
  return
end

---@diagnostic disable-next-line: missing-fields
vim.lsp.start {
  name = 'luals',
  cmd = { lua_ls_cmd },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  filetypes = { 'lua' },
  capabilities = lsp.capabilities,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global, etc.
        globals = {
          'vim',
          'describe',
          'it',
          'assert',
          'stub',
        },
        disable = {
          'duplicate-set-field',
        },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          '${3rd}/busted/library',
          '${3rd}/luassert/library',
        },
      },
      telemetry = {
        enable = false,
      },
      hint = { -- inlay hints
        enable = true,
      },
    },
  },
}
