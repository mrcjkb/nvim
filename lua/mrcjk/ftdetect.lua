vim.filetype.add {
  extension = {
    avsc = 'json', -- avro
    jsonc = 'json',

    -- NOTE: Example for a more complex filetype detection...
    -- SEE: https://www.reddit.com/r/neovim/comments/rvwsl3/introducing_filetypelua_and_a_call_for_help/
    -- h = function()
    --   -- Use a lazy heuristic that #including a C++ header means it's a
    --   -- C++ header
    --   if vim.fn.search('\\C^#include <[^>.]\\+>$', 'nw') == 1 then
    --     return 'cpp'
    --   end
    --   return 'c'
    -- end,
  },
}
