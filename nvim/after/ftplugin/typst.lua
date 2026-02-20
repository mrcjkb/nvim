local files = require('mrcjk.files')
files.treesitter_start()

if not vim.b.highlight_colors_toggled then
  local hc = require('nvim-highlight-colors')
  hc.turnOn()
end

if vim.fn.executable('tinymist') ~= 1 then
  return
end

-- The following is based on nvim-lspconfig, with some small tweaks.
-- TODO: Create a dedicated plugin with a nicer UX and support for more tinymist-specific features?

---@param command_name string
---@param client vim.lsp.Client
---@param bufnr integer
---@return fun():nil run_tinymist_command, string cmd_name, string cmd_desc
local function create_tinymist_command(command_name, client, bufnr)
  local export_type = command_name:match('tinymist%.export(%w+)')
  local info_type = command_name:match('tinymist%.(%w+)')
  local cmd_display = export_type or info_type:gsub('^get', 'Get'):gsub('^pin', 'Pin')

  ---@return nil
  local function run_tinymist_command()
    local arguments = { vim.api.nvim_buf_get_name(bufnr) }
    local title_str = export_type and ('Export ' .. cmd_display) or cmd_display

    ---@type lsp.Handler
    local function handler(err, res)
      if err then
        return vim.notify(err.code .. ': ' .. err.message, vim.log.levels.ERROR)
      end
      vim.notify(vim.inspect(res), vim.log.levels.INFO)
    end

    return client:exec_cmd({
      title = title_str,
      command = command_name,
      arguments = arguments,
    }, { bufnr = bufnr }, handler)
  end
  -- Construct a readable command name/desc
  local cmd_name = export_type and ('TinymistExport' .. cmd_display) or ('Tinymist' .. cmd_display) ---@type string
  local cmd_desc = export_type and ('Export to ' .. cmd_display) or ('Get ' .. cmd_display) ---@type string
  return run_tinymist_command, cmd_name, cmd_desc
end

local root_files = {
  'slides.typ',
  '.git',
}

---@type vim.lsp.Config
vim.lsp.start {
  name = 'tinymist',
  cmd = { 'tinymist' },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  on_attach = function(client, bufnr)
    for _, command in ipairs {
      'tinymist.exportSvg',
      'tinymist.exportPng',
      'tinymist.exportPdf',
      'tinymist.exportMarkdown',
      'tinymist.exportText',
      'tinymist.exportQuery',
      'tinymist.exportAnsiHighlight',
      'tinymist.getServerInfo',
      'tinymist.getDocumentTrace',
      'tinymist.getWorkspaceLabels',
      'tinymist.getDocumentMetrics',
      'tinymist.pinMain',
    } do
      local cmd_func, cmd_name, cmd_desc = create_tinymist_command(command, client, bufnr)
      vim.api.nvim_buf_create_user_command(bufnr, cmd_name, cmd_func, { nargs = 0, desc = cmd_desc })
    end
  end,
}
