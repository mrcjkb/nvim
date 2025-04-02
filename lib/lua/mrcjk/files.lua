local files = {}

local disabled_files = {
  'Enums.hs',
  'all-packages.nix',
  'hackage-packages.nix',
  'generated.nix',
}

---@param bufnr number
---@return boolean
local function disable_treesitter_features(bufnr)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  local short_name = vim.fn.fnamemodify(fname, ':t')
  if vim.tbl_contains(disabled_files, short_name) then
    return true
  end
  local max_filesize = 100 * 1024 -- 100 KiB
  local ok, stats = pcall(vim.uv.fs_stat, fname)
  if ok and stats and stats.size > max_filesize then
    return true
  end
  return false
end

vim.cmd.packadd('nvim-treesitter')
---@diagnostic disable: missing-fields
local configs = require('nvim-treesitter.configs')
configs.setup {
  matchup = {
    enable = true, -- mandatory, false will disable the whole extension
    disable = { 'python' },
  },
  incremental_selection = {
    enable = false,
  },
}

require('treesitter-context').setup {
  max_lines = 3,
}

require('nvim-treesitter-textobjects').setup {
  select = {
    -- Automatically jump forward to textobjects, similar to targets.vim
    lookahead = true,
    selection_modes = {
      ['@parameter.outer'] = 'v', -- charwise
      ['@function.outer'] = 'V', -- linewise
      ['@class.outer'] = '<c-v>', -- blockwise
    },
  },
  move = {
    -- whether to set jumps in the jumplist
    set_jumps = true,
  },
}

vim.cmd.packadd('vim-illuminate')
local illuminate = require('illuminate')
illuminate.configure {
  delay = 200,
  should_enable = function(bufnr)
    return not disable_treesitter_features(bufnr)
  end,
}

require('todo-comments').setup {
  highlight = {
    pattern = {
      [[.*<(KEYWORDS)\s*:]],
      [[.*<(KEYWORDS)\s*]],
      [[.*<(KEYWORDS)\(.*\)\s*:]],
    },
  },
}

---@param lang? string
---@param bufnr? number
function files.treesitter_start(lang, bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  lang = lang or vim.bo[bufnr].ft
  if disable_treesitter_features(bufnr) then
    return
  end
  vim.treesitter.start(bufnr, lang)

  if vim.treesitter.query.get(lang, 'indents') then
    vim.bo[bufnr].indentexpr = "v:lua.require('mrcjk.indentexpr').indentexpr()"
  else
    vim.bo[bufnr].autoindent = true
    vim.bo[bufnr].smartindent = true
  end

  -- select
  vim.keymap.set({ 'x', 'o' }, 'af', function()
    require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
  end, { buffer = bufnr })
  vim.keymap.set({ 'x', 'o' }, 'if', function()
    require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
  end, { buffer = bufnr })
  vim.keymap.set({ 'x', 'o' }, 'ac', function()
    require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects')
  end, { buffer = bufnr })
  vim.keymap.set({ 'x', 'o' }, 'ic', function()
    require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects')
  end, { buffer = bufnr })
  vim.keymap.set({ 'x', 'o' }, 'as', function()
    require('nvim-treesitter-textobjects.select').select_textobject('@local.scope', 'locals')
  end, { buffer = bufnr })

  -- swap
  vim.keymap.set('n', '<leader>a', function()
    require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner')
  end, { buffer = bufnr })
  vim.keymap.set('n', '<leader>A', function()
    require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.outer')
  end, { buffer = bufnr })

  -- move
  vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
    require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
  end, { buffer = bufnr, desc = '[m] next function (start)' })
  vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
    require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
  end, { buffer = bufnr, desc = '[M] next function (end)' })
  vim.keymap.set({ 'n', 'x', 'o' }, ']p', function()
    require('nvim-treesitter-textobjects.move').goto_next_start('@parameter.outer', 'textobjects')
  end, { buffer = bufnr, desc = '[p] next parameter (start)' })
  vim.keymap.set({ 'n', 'x', 'o' }, ']P', function()
    require('nvim-treesitter-textobjects.move').goto_next_end('@parameter.outer', 'textobjects')
  end, { buffer = bufnr, desc = '[P] next parameter (end)' })
  vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
    require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
  end, { buffer = bufnr, desc = '[m] previous function (start)' })
  vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
    require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
  end, { buffer = bufnr, desc = '[M] previous function (end)' })
  vim.keymap.set({ 'n', 'x', 'o' }, '[p', function()
    require('nvim-treesitter-textobjects.move').goto_previous_start('@parameter.outer', 'textobjects')
  end, { buffer = bufnr, desc = 'previous [p]arameter (start)' })
  vim.keymap.set({ 'n', 'x', 'o' }, '[P', function()
    require('nvim-treesitter-textobjects.move').goto_previous_end('@parameter.outer', 'textobjects')
  end, { buffer = bufnr, desc = 'previous [P]arameter (end)' })

  -- illuminate
  vim.keymap.set('n', ']]', function()
    illuminate.goto_next_reference(true)
  end, { noremap = true, silent = true, buffer = bufnr, desc = 'next reference' })
  vim.keymap.set('n', '[[', function()
    illuminate.goto_prev_reference(true)
  end, { noremap = true, silent = true, buffer = bufnr, desc = 'previous reference' })

  vim.keymap.set('n', ']t', function()
    require('todo-comments').jump_next { keywords = { 'TODO' } }
  end, { buffer = bufnr, desc = 'Next [t]odo comment' })

  vim.keymap.set('n', '[t', function()
    require('todo-comments').jump_prev { keywords = { 'TODO' } }
  end, { buffer = bufnr, desc = 'Previous [t]odo comment' })
end

return files
