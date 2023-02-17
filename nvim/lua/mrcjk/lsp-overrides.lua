local handlers = vim.lsp.handlers
local util = vim.lsp.util
-- local api = vim.api

local M = {}

local function response_to_qflist_override(map_result, entity)
  return function(_, _, result, _, bufnr)
    if not result or vim.tbl_isempty(result) then
      vim.notify('No ' .. entity .. ' found')
    else
      util.set_qflist(map_result(result, bufnr))
    end
  end
end

function M.setup()
  handlers['textDocument_references'] = response_to_qflist_override(util.locations_to_items, 'references')
end

return M
