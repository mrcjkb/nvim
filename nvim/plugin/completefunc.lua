--- Implements custom completion for 'completefunc'
---
--- - See |complete-functions|
--- - See |complete-items|
--- - See |CompleteDone|
---
--- @param findstart integer 0 or 1, decides behavior
--- @param base integer findstart=0, text to match against
---
--- @return integer|table Decided by {findstart}:
--- - findstart=0: column where the completion starts, or -2 or -3
--- - findstart=1: list of matches (actually just calls |complete()|)
function _G.completefunc(findstart, base)
  return { 'a', 'b', 'c' }
  --
  -- Return -2 to signal that we should continue completion so that we can
  -- async complete.
  -- return -2
end

-- in async complete: vim.fn.complete(start_col, matches)

-- vim.o.completefunc = 'v:lua._G.completefunc'
