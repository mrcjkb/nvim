local M = {}

--- @class lsp.codelens.GetOpts
--- @field lnum? integer

--- @class lsp.codelens.GotoOpts: vim.codelens.GetOpts
--- @field cursor_position? {[1]:integer,[2]:integer}
--- @field wrap? integer
--- @field win_id? integer
--- @field predicate? fun(lens: lsp.CodeLens):boolean

--- @param lenses lsp.CodeLens[]
--- @return table<integer,lsp.CodeLens[]>
local function lenses_by_lines(lenses)
  if not lenses then
    return {}
  end

  local lenses_by_lnum = {} --- @type table<integer,vim.Diagnostic[]>
  for _, lens in ipairs(lenses) do
    local line_lenses = lenses_by_lnum[lens.range.start.line]
    if not line_lenses then
      line_lenses = {}
      lenses_by_lnum[lens.range.start.line] = line_lenses
    end
    table.insert(line_lenses, lens)
  end
  return lenses_by_lnum
end

--- @param position {[1]: integer, [2]: integer}
--- @param search_forward boolean
--- @param bufnr integer
--- @param opts lsp.codelens.GotoOpts
--- @return lsp.CodeLens?
local function next_codelens(position, search_forward, bufnr, opts)
  position[1] = position[1] - 1
  bufnr = (not bufnr or bufnr == 0) and vim.api.nvim_get_current_buf() or bufnr
  local wrap = opts.wrap == nil and true or opts.wrap
  local predicate = opts.predicate or function()
    return true
  end
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  local lenses = vim.lsp.codelens.get(bufnr)
  local lenses_by_lnum = lenses_by_lines(lenses)

  for i = 0, line_count do
    local offset = i * (search_forward and 1 or -1)
    local lnum = position[1] + offset
    if lnum < 0 or lnum >= line_count then
      if not wrap then
        return
      end
      lnum = (lnum + line_count) % line_count
    end
    if lenses_by_lnum[lnum] and not vim.tbl_isempty(lenses_by_lnum[lnum]) then
      local line_length = #vim.api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, true)[1]
      --- @type function, function
      local sort_lenses, is_next
      if search_forward then
        ---@param a lsp.CodeLens
        ---@param b lsp.CodeLens
        sort_lenses = function(a, b)
          return a.range.start.character < b.range.start.character
        end
        ---@param d lsp.CodeLens
        is_next = function(d)
          return predicate(d) and math.min(d.range.start.character, line_length - 1) > position[2]
        end
      else
        ---@param a lsp.CodeLens
        ---@param b lsp.CodeLens
        sort_lenses = function(a, b)
          return a.range.start.character > b.range.start.character
        end
        ---@param d lsp.CodeLens
        is_next = function(d)
          return predicate(d) and math.min(d.range.start.character, line_length - 1) < position[2]
        end
      end
      table.sort(lenses_by_lnum[lnum], sort_lenses)
      if i == 0 then
        for _, v in
          pairs(lenses_by_lnum[lnum] --[[@as table<string,any>]])
        do
          if is_next(v) then
            return v
          end
        end
      else
        return lenses_by_lnum[lnum][1]
      end
    end
  end
end

--- @param opts lsp.codelens.GotoOpts?
--- @param pos {[1]:integer,[2]:integer}|false
local function codelens_move_pos(opts, pos)
  opts = opts or {}

  local win_id = opts.win_id or vim.api.nvim_get_current_win()

  if not pos then
    vim.api.nvim_echo({ { 'No more valid codelenses to move to', 'WarningMsg' } }, true, {})
    return
  end

  vim.api.nvim_win_call(win_id, function()
    -- Save position in the window's jumplist
    vim.cmd("normal! m'")
    vim.api.nvim_win_set_cursor(win_id, { pos[1] + 1, pos[2] })
    -- Open folds under the cursor
    vim.cmd('normal! zv')
  end)
end

--- Get the previous codelens closest to the cursor position.
---
---@param opts? lsp.codelens.GotoOpts (table) See |lsp.codelens.goto_next()|
---@return lsp.CodeLens? Previous codelens
function M.get_prev(opts)
  opts = opts or {}

  local win_id = opts.win_id or vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_win_get_buf(win_id)
  local cursor_position = opts.cursor_position or vim.api.nvim_win_get_cursor(win_id)

  return next_codelens(cursor_position, false, bufnr, opts)
end

--- Return the position of the previous codelens in the current buffer.
---
---@param opts? lsp.codelens.GotoOpts (table) See |lsp.codelens.goto_next()|
---@return table|false: Previous codelens position as a (row, col) tuple or false if there is no
---                     prior codelens
function M.get_prev_pos(opts)
  local prev = M.get_prev(opts)
  if not prev then
    return false
  end
  return { prev.range.start.line, prev.range.start.character }
end

--- Move to the previous codelens in the current buffer.
---@param opts? lsp.codelens.GotoOpts (table) See |lsp.codelens.goto_next()|
function M.goto_prev(opts)
  return codelens_move_pos(opts, M.get_prev_pos(opts))
end

--- Get the next codelens closest to the cursor position.
---
---@param opts? lsp.codelens.GotoOpts (table) See |lsp.codelens.goto_next()|
---@return lsp.CodeLens? : Next codelens
function M.get_next(opts)
  opts = opts or {}

  local win_id = opts.win_id or vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_win_get_buf(win_id)
  local cursor_position = opts.cursor_position or vim.api.nvim_win_get_cursor(win_id)

  return next_codelens(cursor_position, true, bufnr, opts)
end

--- Return the position of the next codelens in the current buffer.
---
---@param opts? lsp.codelens.GotoOpts (table) See |lsp.codelens.goto_next()|
---@return table|false : Next codelens position as a (row, col) tuple or false if no next
---                      codelens.
function M.get_next_pos(opts)
  local next = M.get_next(opts)
  if not next then
    return false
  end
  return { next.range.start.line, next.range.start.character }
end

--- Move to the next codelens.
---
---@param opts? lsp.codelens.GotoOpts (table) Configuration table with the following keys:
---         - cursor_position: (cursor position) Cursor position as a (row, col) tuple.
---                          See |nvim_win_get_cursor()|. Defaults to the current cursor position.
---         - wrap: (boolean, default true) Whether to loop around file or not. Similar to 'wrapscan'.
---         - win_id: (number, default 0) Window ID
---         - predicate: (function) A predicate for filtering code lenses.
function M.goto_next(opts)
  codelens_move_pos(opts, M.get_next_pos(opts))
end

return M
