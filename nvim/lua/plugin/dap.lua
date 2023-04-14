local dap = require('dap')
local dapui = require('dapui')
local dapvt = require('nvim-dap-virtual-text')

-- Virtual text
vim.g.dap_virtual_text = true
-- request variable values for all frames (experimental)
vim.g.dap_virtual_text = 'all frames'

-- dap-ui
-- require("dapui").setup()

-- dap

dap.toggle_conditional_breakpoint = function()
  dap.toggle_breakpoint(vim.fn.input { prompt = 'Breakpoint condition: ' }, nil, nil, true)
end
local widgets = require('dap.ui.widgets')
dap.sidebar = widgets.sidebar(widgets.scopes)

vim.fn.sign_define('DapBreakpoint', { text = '', texthl = '', linehl = '', numhl = '' })

local commands = {
  {
    'DapContinue',
    dap.continue,
    {},
  },
  {
    'DapBreakpoints',
    dap.list_breakpoints,
    {},
  },
  {
    'DapSidebar',
    function()
      require('dap-setup').sidebar.toggle()
    end,
    {},
  },
}
for _, command in ipairs(commands) do
  vim.api.nvim_create_user_command(unpack(command))
end

dap.defaults.fallback.external_terminal = {
  command = 'alacritty',
  args = { '-e' },
}

dapui.setup()
dapvt.setup()
