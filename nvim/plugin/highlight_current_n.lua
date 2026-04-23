-- Highlight word being searched for

if vim.g.loaded_highlight_current_n then
  return
end
vim.g.loaded_highlight_current_n = true

local api = vim.api

local highlight_cur_n_group = api.nvim_create_augroup('highlight-current-n', { clear = true })
api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    local search = api.nvim_get_hl(0, { name = 'Search' })
    ---@diagnostic disable-next-line: cast-type-mismatch
    ---@cast search vim.api.keyset.highlight
    api.nvim_set_hl(0, 'CurSearch', { link = 'IncSearch' })
    api.nvim_set_hl(0, 'SearchCurrentN', search)
    return api.nvim_set_hl(0, 'Search', { link = 'SearchCurrentN' })
  end,
  group = highlight_cur_n_group,
})
api.nvim_create_autocmd('CmdlineEnter', {
  pattern = '/,\\?',
  callback = function()
    vim.opt.hlsearch = true
    vim.opt.incsearch = true
    return api.nvim_set_hl(0, 'Search', { link = 'SearchCurrentN' })
  end,
  group = highlight_cur_n_group,
})
api.nvim_create_autocmd('CmdlineLeave', {
  pattern = '/,\\?',
  callback = function()
    api.nvim_set_hl(0, 'Search', {})
    local function _4_()
      vim.opt.hlsearch = true
      return nil
    end
    return vim.defer_fn(_4_, 5) ~= nil
  end,
  group = highlight_cur_n_group,
})
api.nvim_create_autocmd({ 'InsertEnter', 'CursorMoved' }, {
  callback = vim.schedule_wrap(function()
    vim.cmd.nohlsearch()
  end),
  group = highlight_cur_n_group,
})
