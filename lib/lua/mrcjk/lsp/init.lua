---@diagnostic disable: cast-local-type
local lsp = {}

local keymap = vim.keymap

local function init_dap()
  if vim.g.dap_did_setup then
    return
  end
  vim.g.dap_did_setup = true
  local dap = require('dap')
  local dapui = require('dapui')

  -- Virtual text
  vim.g.dap_virtual_text = true
  -- request variable values for all frames (experimental)
  vim.g.dap_virtual_text = 'all frames'

  -- dap

  dap.toggle_conditional_breakpoint = function()
    dap.toggle_breakpoint(vim.fn.input { prompt = 'Breakpoint condition: ' }, nil, nil, true)
  end
  local widgets = require('dap.ui.widgets')
  dap.sidebar = widgets.sidebar(widgets.scopes)

  vim.fn.sign_define('DapBreakpoint', { text = '', texthl = '', linehl = '', numhl = '' })

  dap.defaults.fallback.external_terminal = {
    command = 'alacritty',
    args = { '-e' },
  }

  dapui.setup()
end

function lsp.on_dap_attach(_, bufnr)
  init_dap()
  local dap = require('dap')
  local dap_widgets = require('dap.ui.widgets')
  local dap_utils = require('dap.utils')
  local dapui = require('dapui')
  local function desc(description)
    return { noremap = true, silent = true, buffer = bufnr, desc = description }
  end
  keymap.set('n', '<leader>dS', dap.stop, desc('[d]ap: [S]top'))
  keymap.set('n', '<Up>', dap.step_out, desc('dap: step out'))
  keymap.set('n', '<Down>', dap.step_into, desc('dap: sep into'))
  keymap.set('n', '<Right>', dap.step_over, desc('dap: step over'))
  keymap.set('n', '<space>dC', dap.continue, desc('[d]ap: [C]ontinue'))
  keymap.set('n', '<leader>b', dap.toggle_breakpoint, desc('dap: toggle [b]reakpoint'))
  -- keymap.set('n', '<leader>B', dap.toggle_conditional_breakpoint, opts) -- FIXME
  keymap.set('n', '<leader>dr', function()
    dap.repl.toggle { height = 15 }
  end, desc('[d]ap: toggl [r]epl'))
  keymap.set('n', '<leader>dl', dap.run_last, desc('[d]ap: run [l]ast debug session'))
  keymap.set('n', '<leader>dS', function()
    dap_widgets.centered_float(dap_widgets.frames)
  end, desc('[d]ap: centered floating widget (frames) [S]'))
  keymap.set('n', '<leader>ds', function()
    dap_widgets.centered_float(dap_widgets.scopes)
  end, desc('[d]ap: centered floating widget ([s]copes)'))
  keymap.set('n', '<leader>dh', dap_widgets.hover, desc('[d]ap: [h]over'))
  keymap.set('v', '<leader>dh', function()
    dap_widgets.hover(dap_utils.get_visual_selection_text)
  end, desc('[d]ap: [h]over'))
  keymap.set('v', '<leader>de', dapui.eval, desc('[d]ap: [e]valuate'))
  keymap.set('v', '<M-k>', dapui.float_element, desc('dap: show element in floating window'))
  keymap.set('n', '<leader>du', dapui.toggle, desc('[d]ap: toggle [u]i'))
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_cmp_lsp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if has_cmp_lsp then
  capabilities = vim.tbl_deep_extend('force', capabilities, cmp_lsp.default_capabilities())
end

-- foldingRange capabilities provided by the nvim-ufo plugin
---@diagnostic disable-next-line: inject-field
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

---@type lsp.ClientCapabilities
---@diagnostic disable-next-line: assign-type-mismatch
lsp.capabilities = capabilities

return lsp
