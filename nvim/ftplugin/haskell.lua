require('lang.haskell')
local ht = require('haskell-tools')

local bufnr = vim.api.nvim_get_current_buf()
local keymap_opts = { noremap = true, silent = true, buffer = bufnr }
vim.keymap.set('n', '<leader>rr', ht.repl.toggle, keymap_opts)
vim.keymap.set('n', '<leader>rl', ht.repl.reload, keymap_opts)
vim.keymap.set('n', '<leader>rf', function()
  ht.repl.toggle(vim.api.nvim_buf_get_name(bufnr))
end, keymap_opts)
vim.keymap.set('n', '<leader>rq', ht.repl.quit, keymap_opts)
vim.keymap.set('n', '<leader>rp', ht.repl.paste, keymap_opts)
vim.keymap.set('n', '<leader>rt', ht.repl.paste_type, keymap_opts)
vim.keymap.set('n', '<leader>rw', ht.repl.cword_type, keymap_opts)
-- TODO: remove when ambiguous target issue is resolved
vim.keymap.set('n', '<leader>tt', '<cmd>TermExec cmd="cabal v2-repl %"<CR>', keymap_opts)

-- nvim-surround

---@param items string[]
---@param prompt string?
---@param label_fn (fun(item:string):string) | nil
---@return string|nil
local function ui_select_sync(items, prompt, label_fn)
  label_fn = label_fn or function(str)
    return str
  end
  local choices = { prompt }
  for i, item in ipairs(items) do
    table.insert(choices, string.format('%d: %s', i, label_fn(item)))
  end
  local choice = vim.fn.inputlist(choices)
  if choice < 1 or choice > #items then
    return nil
  end
  return items[choice]
end

---@diagnostic disable-next-line: missing-fields
require('nvim-surround').buffer_setup {
  surrounds = {
    ---@diagnostic disable-next-line: missing-fields
    ['L'] = {
      add = function()
        local level = ui_select_sync({ 'e', 'w', 'i', 'd', 't' }, 'Select a log level')
        return level and { {
          '[Log.' .. level .. '|',
        }, { '|]' } } or {}
      end,
      -- TODO: Use tree-sitter query (see ["f"]) in nvim-surround
    },
    ---@diagnostic disable-next-line: missing-fields
    ['Q'] = {
      add = { '[qq|', '|]' },
    },
  },
}
