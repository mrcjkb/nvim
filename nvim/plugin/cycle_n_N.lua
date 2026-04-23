
if vim.g.loaded_cycle_n_N then
  return
end
vim.g.loaded_cycle_n_N = true

local api = vim.api
local keymap = vim.keymap

local function handle_n_N(key)
  do
    local function other(mode)
      if mode == 'n' then
        return 'N'
      elseif mode == 'N' then
        return 'n'
      else
        return nil
      end
    end
    local function feed(keys)
      return api.nvim_feedkeys(keys, 'n', true)
    end
    if vim.v.searchforward == 0 then
      feed(other(key))
    elseif vim.v.searchforward == 1 then
      feed(key)
    end
  end
  return vim.defer_fn(function()
    vim.opt.hlsearch = true
    return nil
  end, 5)
end
keymap.set({ 'n' }, 'n', function()
  return handle_n_N('n')
end)
keymap.set({ 'n' }, 'N', function()
  return handle_n_N('N')
end)

