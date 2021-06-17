local handlers = vim.lsp.handlers
local util = vim.lsp.util

local M = {}

function M.setup()
  handlers['textDocument/references'] = function(_, _, result)
    if not result then return end
    util.set_qflist(util.locations_to_items(result))
  end
end

return M
