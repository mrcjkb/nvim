local telescope = require('telescope')

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

local function jj_files()
  builtin.git_files {
    prompt_title = 'jj Files',
    git_command = { 'jj', 'file', 'list', '--no-pager' },
  }
end

-- Fall back to find_files if not in a git repo
local project_files = function()
  local opts = {} -- define here if you want to define something
  local ok
  if vim.fn.executable('jj') == 1 then
    ok = pcall(jj_files, opts)
  end
  if not ok then
    ok = pcall(builtin.git_files, opts)
  end
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
    vimgrep_arguments = vim
      .iter({
        conf.vimgrep_arguments,
        additional_vimgrep_arguments,
      })
      :flatten()
      :totable(),
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
end, { desc = 'telescope: find files' })
vim.keymap.set('n', '<leader>tO', builtin.oldfiles, { desc = '[t]elescope: [O]ld files' })
vim.keymap.set('n', '<leader>ts', builtin.live_grep, { desc = '[t]elescope: live grep (regex [s]earch)' })
vim.keymap.set('n', '<C-g>', function()
  local conf = require('telescope.config').values
  builtin.live_grep {
    vimgrep_arguments = table.insert(conf.vimgrep_arguments, '-F'),
  }
end, { desc = 'telescope: live grep (no regex)' })
vim.keymap.set('n', '<leader>tf', fuzzy_grep, { desc = '[t]elescope: [f]uzzy grep' })
vim.keymap.set('n', '<M-f>', fuzzy_grep_current_file_type, { desc = 'telescope: fuzzy grep filetype' })
vim.keymap.set('n', '<M-g>', live_grep_current_file_type, { desc = 'telescope: live grep filetype' })
vim.keymap.set('n', '<leader>t*', grep_string_current_file_type, { desc = '[t]elescope: grep string [*] filetype' })
vim.keymap.set('n', '<leader>*', builtin.grep_string, { desc = 'telescope: grep string' })
vim.keymap.set('n', '<leader>tg', project_files, { desc = '[t]elescope: project files [g]it' })
vim.keymap.set('n', '<leader>tc', builtin.quickfix, { desc = '[t]elescope: quickfix [c] list' })
vim.keymap.set('n', '<leader>tq', builtin.command_history, { desc = '[t]elescope: command [q] history' })
vim.keymap.set('n', '<leader>tl', builtin.loclist, { desc = '[t]elescope: [l]oclist' })
vim.keymap.set('n', '<leader>tr', builtin.registers, { desc = '[t]elescope: [r]egisters' })
vim.keymap.set('n', '<leader>tP', function()
  extensions.projects.projects()
end, { desc = '[t]elescope: [P]rojects' })
vim.keymap.set('n', '<leader>ty', function()
  extensions.yank_history.yank_history()
end, { desc = '[t]elescope: [y]ank history' })
vim.keymap.set('n', '<leader>tbb', builtin.buffers, { desc = '[t]elescope: [bb]uffers' })
vim.keymap.set('n', '<leader>tbf', builtin.current_buffer_fuzzy_find, { desc = '[t]elescope: [b]uffer [f]uzzy find' })
vim.keymap.set('n', '<leader>td', builtin.lsp_document_symbols, { desc = '[t]elescope: lsp [d]ocument symbols' })
vim.keymap.set('n', '<leader>tm', function()
  extensions.harpoon.marks()
end, { desc = '[t]elescope: harpoon [m]arks' })
vim.keymap.set('n', '<leader>th', function()
  extensions.hoogle.hoogle {
    layout_strategy = 'vertical',
    layout_config = layout_config,
  }
end, { desc = '[t]elescope: [h]oogle' })
vim.keymap.set('n', '<leader>tn', function()
  extensions.manix.manix()
end, { desc = '[t]elescope: ma[n]ix' })
vim.keymap.set('n', '<leader>tN', function()
  extensions.manix.manix { cword = true }
end, { desc = '[t]elescope: ma[N]ix <cword>' })
vim.keymap.set(
  'n',
  '<leader>to',
  builtin.lsp_dynamic_workspace_symbols,
  { desc = '[t]elescope: lsp dynamic w[o]rkspace symbols' }
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
        ['<C-q>'] = function(...)
          require('telescope.actions').send_to_qflist(...)
        end,
        ['<C-l>'] = function(...)
          require('telescope.actions').send_to_loclist(...)
        end,
        ['<C-s>'] = function(...)
          require('telescope.actions').cycle_previewers_next(...)
        end,
        ['<C-a>'] = function(...)
          require('telescope.actions').cycle_previewers_prev(...)
        end,
        ['<c-s>'] = flash,
      },
      n = {
        q = function(...)
          require('telescope.actions').close(...)
        end,
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
telescope.load_extension('zf-native')
telescope.load_extension('smart_history')
-- telescope.load_extension('cheat')
-- telescope.load_extension('ui-select')
