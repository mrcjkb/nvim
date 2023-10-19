local telescope = require('telescope')
local actions = require('telescope.actions')

local function lazy_require(moduleName)
  return setmetatable({}, {
    __index = function(_, key)
      return function(...)
        local module = require(moduleName)
        return module[key](...)
      end
    end,
  })
end

local builtin = lazy_require('telescope.builtin')

local extensions = setmetatable({}, {
  __index = function(_, key)
    if telescope.extensions[key] then
      return telescope.extensions[key]
    end
    telescope.load_extension(key)
    return telescope.extensions[key]
  end,
})

local layout_config = {
  vertical = {
    width = function(_, max_columns)
      return math.floor(max_columns * 0.99)
    end,
    height = function(_, _, max_lines)
      return math.floor(max_lines * 0.99)
    end,
    prompt_position = 'bottom',
    preview_cutoff = 0,
  },
}

-- Fall back to find_files if not in a git repo
local project_files = function()
  local opts = {} -- define here if you want to define something
  local ok = pcall(builtin.git_files, opts)
  if not ok then
    builtin.find_files(opts)
  end
end

local function grep_current_file_type(func, extra_args)
  local current_file_ext = vim.fn.expand('%:e')
  local additional_vimgrep_arguments = {}
  if current_file_ext ~= '' then
    additional_vimgrep_arguments = vim.list_extend(extra_args or {}, {
      '--type',
      current_file_ext,
    })
  end
  local conf = require('telescope.config').values
  func {
    vimgrep_arguments = vim.tbl_flatten {
      conf.vimgrep_arguments,
      additional_vimgrep_arguments,
    },
  }
end

local function grep_string_current_file_type()
  grep_current_file_type(builtin.grep_string)
end

local function live_grep_current_file_type()
  grep_current_file_type(builtin.live_grep)
end

local function fuzzy_grep(opts)
  opts = vim.tbl_extend('error', opts or {}, { search = '', prompt_title = 'Fuzzy grep' })
  builtin.grep_string(opts)
end

local function fuzzy_grep_current_file_type()
  grep_current_file_type(fuzzy_grep)
end

vim.keymap.set('n', '<leader>tp', function()
  builtin.find_files()
end, { desc = '[telescope] find files' })
vim.keymap.set('n', '<M-p>', builtin.oldfiles, { desc = '[telescope] old files' })
vim.keymap.set('n', '<C-g>', builtin.live_grep, { desc = '[telescope] live grep' })
vim.keymap.set('n', '<leader>tf', fuzzy_grep, { desc = '[telescope] fuzzy grep' })
vim.keymap.set('n', '<M-f>', fuzzy_grep_current_file_type, { desc = '[telescope] fuzzy grep filetype' })
vim.keymap.set('n', '<M-g>', live_grep_current_file_type, { desc = '[telescope] live grep filetype' })
vim.keymap.set('n', '<leader>t*', grep_string_current_file_type, { desc = '[telescope] grep string filetype' })
vim.keymap.set('n', '<leader>*', builtin.grep_string, { desc = '[telescope] grep string' })
vim.keymap.set('n', '<leader>tg', project_files, { desc = '[telescope] project files' })
vim.keymap.set('n', '<leader>tc', builtin.quickfix, { desc = '[telescope] quickfix list' })
vim.keymap.set('n', '<leader>tq', builtin.command_history, { desc = '[telescope] command history' })
vim.keymap.set('n', '<leader>tl', builtin.loclist, { desc = '[telescope] loclist' })
vim.keymap.set('n', '<leader>tr', builtin.registers, { desc = '[telescope] registers' })
vim.keymap.set('n', '<leader>tP', function()
  extensions.projects.projects()
end, { desc = '[telescope] projects' })
vim.keymap.set('n', '<leader>ty', function()
  extensions.yank_history.yank_history()
end, { desc = '[telescope] yank history' })
vim.keymap.set('n', '<leader>tbb', builtin.buffers, { desc = '[telescope] buffers' })
vim.keymap.set('n', '<leader>tbf', builtin.current_buffer_fuzzy_find, { desc = '[telescope] fuzzy find (buffer)' })
vim.keymap.set('n', '<leader>td', builtin.lsp_document_symbols, { desc = '[telescope] lsp document symbols' })
vim.keymap.set('n', '<leader>tm', function()
  extensions.harpoon.marks()
end, { desc = '[telescope] harpoon marks' })
vim.keymap.set('n', '<leader>th', function()
  extensions.hoogle.hoogle {
    layout_strategy = 'vertical',
    layout_config = layout_config,
  }
end, { desc = '[telescope] hoogle' })
vim.keymap.set('n', '<leader>tn', function()
  extensions.manix.manix()
end, { desc = '[telescope] manix' })
vim.keymap.set('n', '<leader>n*', function()
  extensions.manix.manix { cword = true }
end, { desc = '[telescope] manix <cword>' })
vim.keymap.set(
  'n',
  '<leader>to',
  builtin.lsp_dynamic_workspace_symbols,
  { desc = '[telescope] lsp dynamic workspace symbols' }
)

local function flash(prompt_bufnr)
  require('flash').jump {
    pattern = '^',
    label = { after = { 0, 0 } },
    search = {
      mode = 'search',
      exclude = {
        function(win)
          return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= 'TelescopeResults'
        end,
      },
    },
    action = function(match)
      local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
      picker:set_selection(match.pos[1] - 1)
    end,
  }
end

telescope.setup {
  defaults = {
    path_display = {
      'truncate',
    },
    layout_strategy = 'vertical',
    layout_config = layout_config,
    mappings = {
      i = {
        ['<C-q>'] = actions.send_to_qflist,
        ['<C-l>'] = actions.send_to_loclist,
        -- ['<esc>'] = actions.close,
        ['<C-s>'] = actions.cycle_previewers_next,
        ['<C-a>'] = actions.cycle_previewers_prev,
        ['<c-s>'] = flash,
      },
      n = {
        q = actions.close,
        s = flash,
      },
    },
    preview = {
      treesitter = true,
    },
    history = {
      path = vim.fn.stdpath('data') .. '/telescope_history.sqlite3',
      limit = 1000,
    },
    color_devicons = true,
    set_env = { ['COLORTERM'] = 'truecolor' },
    prompt_prefix = '   ',
    selection_caret = '  ',
    entry_prefix = '  ',
    initial_mode = 'insert',
    vimgrep_arguments = {
      'rg',
      '-L',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    },
    borderchars = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    },
  },
}

telescope.load_extension('fzy_native')
telescope.load_extension('smart_history')
-- telescope.load_extension('cheat')
-- telescope.load_extension('ui-select')
