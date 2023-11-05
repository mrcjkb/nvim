local api = vim.api

local tempdirgroup = api.nvim_create_augroup('tempdir', { clear = true })
-- Do not set undofile for files in /tmp
api.nvim_create_autocmd('BufWritePre', {
  pattern = '/tmp/*',
  group = tempdirgroup,
  callback = function()
    vim.cmd.setlocal('noundofile')
  end,
})

local numbertoggle = api.nvim_create_augroup('numbertoggle', { clear = true })
-- Toggle between relative/absolute line numbers
api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'CmdlineLeave', 'WinEnter' }, {
  pattern = '*',
  group = numbertoggle,
  callback = function()
    if vim.o.nu and api.nvim_get_mode().mode ~= 'i' then
      vim.opt.relativenumber = true
    end
  end,
})

api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'CmdlineEnter', 'WinLeave' }, {
  pattern = '*',
  group = numbertoggle,
  callback = function()
    if vim.o.nu then
      vim.opt.relativenumber = false
      vim.cmd.redraw()
    end
  end,
})

local nospell_group = api.nvim_create_augroup('nospell', { clear = true })

api.nvim_create_autocmd('TermOpen', {
  group = nospell_group,
  callback = function()
    vim.wo[0].spell = false
  end,
})

api.nvim_create_autocmd('FileType', {
  pattern = 'Neogit*',
  group = nospell_group,
  callback = function(ev)
    if vim.bo[ev.buf].filetype ~= 'NeogitCommitMessage' then
      vim.wo[0].spell = false
    end
  end,
})

local highlight_cur_n_group = api.nvim_create_augroup('highlight-current-n', { clear = true })
api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    local search = api.nvim_get_hl(0, { name = 'Search' })
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
    return vim.defer_fn(_4_, 5)
  end,
  group = highlight_cur_n_group,
})
api.nvim_create_autocmd({ 'InsertEnter', 'CursorMoved' }, {
  callback = vim.schedule_wrap(vim.cmd.nohlsearch),
  group = highlight_cur_n_group,
})
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
vim.keymap.set({ 'n' }, 'n', function()
  return handle_n_N('n')
end)
return vim.keymap.set({ 'n' }, 'N', function()
  return handle_n_N('N')
end)
