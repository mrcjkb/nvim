local rt = require('rust-tools')

local lsp = require('mrcjk.lsp')
local rust_analyzer_on_attach = function(client, bufnr)
  lsp.on_attach(client, bufnr)
  -- Hover actions
  vim.keymap.set('n', '<C-space>', rt.hover_actions.hover_actions, { buffer = bufnr, desc = 'rust: hover actions' })
  -- Code action groups
  vim.keymap.set(
    'n',
    '<Leader>a',
    rt.code_action_group.code_action_group,
    { buffer = bufnr, desc = 'rust: code action group' }
  )
end

local rust_tools_opts = {
  tools = { -- rust-tools options
    autoSetHints = true,
    runnables = {
      use_telescope = true,
    },
    -- these apply to the default RustSetInlayHints command
    inlay_hints = {
      auto = false, -- supported natively
      show_parameter_hints = true,
      parameter_hints_prefix = ' ← ',
      other_hints_prefix = ' ⇒ ',
    },
  },
  -- all the opts to send to nvim-lspconfig
  -- these override the defaults set by rust-tools.nvim
  -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
  server = {
    autostart = false,
    on_attach = rust_analyzer_on_attach,
    capabilities = lsp.capabilities,
  },
}

rt.setup(rust_tools_opts)

return require('lspconfig.configs').rust_analyzer
