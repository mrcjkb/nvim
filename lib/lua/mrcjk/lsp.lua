local lsp = {}

local function preview_location_callback(_, result)
  if result == nil or vim.tbl_isempty(result) then
    return nil
  end
  vim.lsp.util.preview_location(result[1])
end

local function peek_definition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
end

local function peek_type_definition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, 'textDocument/typeDefinition', params, preview_location_callback)
end

local api = vim.api
local keymap = vim.keymap

vim.fn.sign_define('LightBulbSign', { text = '󰌶', texthl = 'LspDiagnosticsDefaultInformation' })
require('nvim-lightbulb').setup {
  autocmd = {
    enabled = false,
  },
  sign = {
    text = '󰌶',
  },
}

require('fidget').setup()

local default_on_codelens = vim.lsp.codelens.on_codelens
vim.lsp.codelens.on_codelens = function(err, lenses, ctx, _)
  if err or not lenses or not next(lenses) then
    return default_on_codelens(err, lenses, ctx, _)
  end
  for _, lens in pairs(lenses) do
    if lens and lens.command and lens.command.title then
      lens.command.title = ' ' .. lens.command.title
    end
  end
  return default_on_codelens(err, lenses, ctx, _)
end

local function code_action()
  if vim.cmd.CodeActionMenu then
    return vim.cmd.CodeActionMenu()
  end
  return vim.lsp.buf.code_action()
end

---@param filter 'Function' | 'Module' | 'Struct'
local function filtered_document_symbol(filter)
  vim.lsp.buf.document_symbol()
  vim.cmd.Cfilter(('[[%s]]'):format(filter))
end

local function document_functions()
  filtered_document_symbol('Function')
end

local function document_modules()
  filtered_document_symbol('Module')
end

local function document_structs()
  filtered_document_symbol('Struct')
end

function lsp.on_attach(client, bufnr)
  vim.cmd.setlocal('signcolumn=yes')

  local function buf_set_option(...)
    api.nvim_buf_set_option(bufnr, ...)
  end
  local function buf_set_var(...)
    api.nvim_buf_set_var(bufnr, ...)
  end

  buf_set_option('bufhidden', 'hide')
  buf_set_var('lsp_client_id', client.id)

  -- Mappings.
  local opts = { noremap = true, silent = true, buffer = bufnr }
  keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  keymap.set('n', '<space>gt', vim.lsp.buf.type_definition, opts)
  -- keymap.set('n', 'K', vim.lsp.buf.hover, opts) -- overriden by nvim-ufo
  keymap.set('n', '<space>pd', peek_definition, opts) -- overriden by nvim-ufo
  keymap.set('n', '<space>pt', peek_type_definition, opts) -- overriden by nvim-ufo
  keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  keymap.set('n', '<M-d>', peek_type_definition, opts) -- overriden by nvim-ufo
  keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
  keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
  keymap.set('n', '<space>wl', function()
    -- TODO: Replace this with a Telescope extension?
    vim.print(vim.lsp.buf.list_workspace_folders())
  end, opts)
  keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
  keymap.set('n', '<space>wq', vim.lsp.buf.workspace_symbol, opts)
  keymap.set('n', '<space>dd', vim.lsp.buf.document_symbol, opts)
  keymap.set('n', '<space>df', document_functions, opts)
  keymap.set('n', '<space>ds', document_structs, opts)
  keymap.set('n', '<space>di', document_modules, opts)
  keymap.set('n', '<M-CR>', code_action, opts)
  keymap.set('n', '<M-l>', vim.lsp.codelens.run, opts)
  keymap.set('n', '<space>cr', vim.lsp.codelens.refresh, opts)
  keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  keymap.set('n', '<space>f', function()
    vim.lsp.buf.format { async = true }
  end, opts)
  keymap.set('n', 'vv', function()
    require('lsp-selection-range').trigger()
  end, opts)
  keymap.set('v', 'vv', function()
    require('lsp-selection-range').expand()
  end, opts)

  -- local navbuddy = require('nvim-navbuddy')
  -- navbuddy.attach(client, bufnr)
  -- keymap.set('n', 'go', navbuddy.open, opts)

  vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    buffer = bufnr,
    group = vim.api.nvim_create_augroup('LightBulb', {}),
    desc = "lua require('nvim-lightbulb').update_lightbulb()",
    callback = require('nvim-lightbulb').update_lightbulb,
  })

  -- Autocomplete signature hints
  require('lsp_signature').on_attach()

  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint(bufnr, true)
    keymap.set('n', '<space>h', function()
      vim.lsp.inlay_hint(bufnr)
    end, opts)
  end

  local function get_active_clients(buf)
    return vim.lsp.get_clients { bufnr = buf, name = client.name }
  end
  local function buf_refresh_codeLens()
    vim.schedule(function()
      for _, c in pairs(get_active_clients(bufnr)) do
        if c.server_capabilities.codeLensProvider then
          vim.lsp.codelens.refresh()
          return
        end
      end
    end)
  end
  local group = api.nvim_create_augroup(string.format('lsp-%s-%s', bufnr, client.id), {})
  if client.server_capabilities.codeLensProvider then
    vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePost', 'TextChanged' }, {
      group = group,
      callback = buf_refresh_codeLens,
      buffer = bufnr,
    })
    buf_refresh_codeLens()
  end
end

function lsp.on_dap_attach(bufnr)
  local dap = require('dap')
  local dap_widgets = require('dap.ui.widgets')
  local dap_utils = require('dap.utils')
  local dapui = require('dapui')
  local opts = { noremap = true, silent = true, buffer = bufnr }
  keymap.set('n', '<F5>', dap.stop, opts)
  keymap.set('n', '<Up>', dap.step_out, opts)
  keymap.set('n', '<Down>', dap.step_into, opts)
  keymap.set('n', '<Right>', dap.step_over, opts)
  keymap.set('n', '<F9>', dap.continue, opts)
  keymap.set('n', '<leader>b', dap.toggle_breakpoint, opts)
  -- keymap.set('n', '<leader>B', dap.toggle_conditional_breakpoint, opts) -- FIXME
  keymap.set('n', '<leader>dr', function()
    dap.repl.toggle { height = 15 }
  end, opts)
  keymap.set('n', '<leader>dl', dap.run_last, opts)
  keymap.set('n', '<leader>dS', function()
    dap_widgets.centered_float(dap_widgets.frames)
  end, opts)
  keymap.set('n', '<leader>ds', function()
    dap_widgets.centered_float(dap_widgets.scopes)
  end, opts)
  keymap.set('n', '<leader>dh', dap_widgets.hover, opts)
  keymap.set('v', '<leader>dH', function()
    dap_widgets.hover(dap_utils.get_visual_selection_text)
  end, opts)
  keymap.set('v', '<M-e>', dapui.eval, opts)
  keymap.set('v', '<M-k>', dapui.float_element, opts)
  keymap.set('n', '<leader>du', dapui.toggle, opts)
end

local has_cmp_lsp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
local capabilities = has_cmp_lsp and cmp_lsp.default_capabilities() or vim.lsp.protocol.make_client_capabilities()
capabilities = require('lsp-selection-range').update_capabilities(capabilities)
-- Enable preliminary support for workspace/didChangeWatchedFiles
vim.tbl_deep_extend('keep', capabilities, {
  workspace = {
    didChangeWatchedFiles = {
      dynamicRegistration = true,
    },
  },
})

-- foldingRange capabilities provided by the nvim-ufo plugin
---@diagnostic disable-next-line: inject-field
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

lsp.capabilities = capabilities

api.nvim_create_autocmd('LspDetach', {
  group = api.nvim_create_augroup('lsp-detach', {}),
  callback = function(args)
    local group = api.nvim_create_augroup(string.format('lsp-%s-%s', args.buf, args.data.client_id), {})
    pcall(api.nvim_del_augroup_by_name, group)
  end,
})

api.nvim_create_user_command('LspStop', function(kwargs)
  local name = kwargs.fargs[1]
  for _, client in pairs(vim.lsp.get_clients()) do
    if client.name == name then
      vim.lsp.stop_client(client.id)
    end
  end
end, {
  nargs = 1,
  complete = function()
    return vim.tbl_map(function(c)
      return c.name
    end, vim.lsp.get_clients())
  end,
})

return lsp
