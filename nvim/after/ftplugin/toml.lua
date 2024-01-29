local keymap = vim.keymap

local bufnr = vim.api.nvim_get_current_buf()
if vim.b[bufnr].mrcjkb_did_ftplugin then
  return
end
vim.b[bufnr].mrcjkb_did_ftplugin = true

local buf_filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':t')

if not vim.g.did_crates_nvim_init and buf_filename == 'Cargo.toml' then
  local function code_action()
    return require('actions-preview').code_actions()
    -- return vim.lsp.buf.code_action()
  end

  require('crates').setup {
    lsp = {
      enabled = true,
      on_attach = function(_, buf)
        local function desc(description)
          return { noremap = true, silent = true, buffer = buf, desc = description }
        end
        keymap.set('n', '<M-CR>', code_action, desc('[lsp] code action'))
        keymap.set('n', 'K', function()
          vim.cmd.Crates('show_popup')
        end, desc('[crates] popup'))
        keymap.set('n', '<space>cd', function()
          vim.cmd.Crates('show_dependencies_popup')
        end, desc('[crates] dependencies'))
        keymap.set('n', '<space>cf', function()
          vim.cmd.Crates('show_features_popup')
        end, desc('[crates] features'))
        keymap.set('n', '<space>cua', function()
          vim.cmd.Crates('update_crates')
        end, desc('[crates] update all'))
        keymap.set('n', '<space>cuc', function()
          vim.cmd.Crates('update_crate')
        end, desc('[crates] update crate'))
        keymap.set('n', '<space>coc', function()
          vim.cmd.Crates('open_cratesio')
        end, desc('[crates] update crate'))
        keymap.set('n', '<space>cod', function()
          vim.cmd.Crates('open_documentation')
        end, desc('[crates] update crate'))
        keymap.set('n', '<space>cor', function()
          vim.cmd.Crates('open_repository')
        end, desc('[crates] update crate'))
      end,
      actions = true,
      completion = true,
    },
  }
  vim.g.did_crates_nvim_init = true
end

local lsp = require('mrcjk.lsp')

if vim.fn.executable('taplo') ~= 1 then
  return
end

vim.lsp.start {
  name = 'taplo',
  cmd = { 'taplo', 'lsp', 'stdio' },
  capabilities = lsp.capabilities,
  on_attach = lsp.on_attach,
  init_options = {
    configurationSection = 'evenBetterToml',
    cachePath = vim.NIL,
  },
  root_dir = vim.fs.dirname(vim.fs.find({ 'taplo.toml', '.taplo.toml' }, { upward = true })[1]),
}
