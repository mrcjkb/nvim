local files = require('mrcjk.files')
files.treesitter_start()

local bufnr = vim.api.nvim_get_current_buf()
require('lang.haskell').set_keymaps()
require('mrcjk.neotest')
local ht = require('haskell-tools')

local function desc(description)
  return { noremap = true, silent = true, buffer = bufnr, desc = description }
end
vim.keymap.set('n', '<leader>rr', ht.repl.toggle, desc('haskell: toggle [rr]epl'))
vim.keymap.set('n', '<leader>rl', ht.repl.reload, desc('haskell: [r]epl re[l]oad'))
vim.keymap.set('n', '<leader>rf', function()
  ht.repl.toggle(vim.api.nvim_buf_get_name(bufnr))
end, desc('haskell: [r]epl toggle with [f]ile'))
vim.keymap.set('n', '<leader>rq', ht.repl.quit, desc('haskell: [r]epl [q]uit'))
vim.keymap.set('n', '<leader>rp', ht.repl.paste, desc('haskell: [r]epl [p]aste'))
vim.keymap.set('n', '<leader>rt', ht.repl.paste_type, desc('haskell: [r]epl paste [t]ype from <register>'))
vim.keymap.set('n', '<leader>rw', ht.repl.cword_type, desc('haskell: [r]epl type of <c[w]ord>'))
-- TODO: remove when ambiguous target issue is resolved
vim.keymap.set(
  'n',
  '<leader>tt',
  '<cmd>TermExec cmd="cabal repl %"<CR>',
  desc('haskell: start `cabal repl %` in [tt]erminal')
)

vim.keymap.set(
  'n',
  '<space>a',
  '<Plug>HaskellHoverAction',
  { noremap = true, silent = true, desc = 'haskell: hover [a]ction' }
)

vim.keymap.set('n', '<leader>os', function()
  vim.cmd.Other('spec')
end, desc('[o]ther: [s]pec'))

vim.keymap.set('n', '<leader>ot', function()
  vim.cmd.Other('test')
end, desc('[o]ther: [t]est'))

vim.keymap.set('n', '<leader>oi', function()
  vim.cmd.Other('impl')
end, desc('[o]ther: [i]mpl'))

vim.keymap.set('n', '<leader>oI', function()
  vim.cmd.Other('internal-impl')
end, desc('[o]ther: [I]nternal-impl'))

vim.keymap.set('n', '<leader>on', function()
  vim.cmd.Other('internal')
end, desc('[o]ther: i[n]ternal'))

if vim.fn.executable('pre-commit') == 1 then
  vim.keymap.set('n', '<leader>pf', function()
    vim.system({ 'pre-commit', 'run', '--file', vim.api.nvim_buf_get_name(bufnr), 'fourmolu' }, nil, function()
      vim.schedule(function()
        vim.cmd.checktime()
      end)
    end)
  end, { noremap = true, silent = true, buffer = bufnr, desc = 'pre-commit run fourmolu' })
end

-- nvim-surround

if not vim.g.nvim_surround_setup then
  require('nvim-surround').setup()
  vim.g.nvim_surround_setup = true
end

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
