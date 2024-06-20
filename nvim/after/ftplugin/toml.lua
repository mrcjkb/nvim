local keymap = vim.keymap

local bufnr = vim.api.nvim_get_current_buf()
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
        keymap.set('n', '<M-CR>', code_action, desc('lsp: code action'))
        keymap.set('n', 'K', function()
          vim.cmd.Crates('show_popup')
        end, desc('crates: popup'))
        keymap.set('n', '<space>cd', function()
          vim.cmd.Crates('show_dependencies_popup')
        end, desc('[c]rates: [d]ependencies'))
        keymap.set('n', '<space>cf', function()
          vim.cmd.Crates('show_features_popup')
        end, desc('[c]rates: [f]eatures'))
        keymap.set('n', '<space>cua', function()
          vim.cmd.Crates('update_crates')
        end, desc('[c]rates: [u]pdate [a]ll'))
        keymap.set('n', '<space>cuc', function()
          vim.cmd.Crates('update_crate')
        end, desc('[c]rates: [u]pdate [c]rate'))
        keymap.set('n', '<space>coc', function()
          vim.cmd.Crates('open_cratesio')
        end, desc('[c]rates: [o]open [c]rates.io'))
        keymap.set('n', '<space>cod', function()
          vim.cmd.Crates('open_documentation')
        end, desc('[c]rates: [o]pen [d]ocumentaion'))
        keymap.set('n', '<space>cor', function()
          vim.cmd.Crates('open_repository')
        end, desc('[c]rates: [o]pen [r]epository'))
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
  init_options = {
    configurationSection = 'evenBetterToml',
    cachePath = vim.NIL,
  },
  root_dir = vim.fs.dirname(vim.fs.find({ 'taplo.toml', '.taplo.toml' }, { upward = true })[1]),
}
