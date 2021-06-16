local if_nil = vim.F.if_nil
local protocol = require('vim.lsp.protocol')
local util = require('vim.lsp.util')
local diagnostic = require('vim.lsp.diagnostic')

local M = {}

local DiagnosticSeverity = protocol.DiagnosticSeverity
local to_severity = function(severity)
  if not severity then return nil end
  return type(severity) == 'string' and DiagnosticSeverity[severity] or severity
end

--- Sets the quickfix list
---@param opts table|nil Configuration table. Keys:
---         - {open_qflist}: (boolean, default true)
---             - Open quickfix list after set
---         - {client_id}: (number)
---             - If nil, will consider all clients attached to buffer.
---         - {severity}: (DiagnosticSeverity)
---             - Exclusive severity to consider. Overrides {severity_limit}
---         - {severity_limit}: (DiagnosticSeverity)
---             - Limit severity of diagnostics found. E.g. "Warning" means { "Error", "Warning" } will be valid.
function M.diagnostics_set_qflist(opts)
  opts = opts or {}
  local open_qflist = if_nil(opts.onen_qflist, true)
  local diags = diagnostic.get_all(opts.client_id) 
  local predicate = function(d)
    local severity = to_severity(opts.severity)
    if severity then
      return d.severity == severity
    end
    severity = to_severity(opts.severity_limit)
    if severity then
      return d.severity == severity
    end
    return true
  end
  local items = util.diagnostics_to_items(diags, predicate)
  util.set_qflist(items)
  if open_qflist then
    vim.cmd [[copen]]
  end
end

return M
