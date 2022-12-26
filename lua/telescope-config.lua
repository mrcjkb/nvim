local telescope = require('telescope')
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')
local themes = require('telescope.themes')

-- Fall back to find_files if not in a git repo
local project_files = function()
  local opts = {} -- define here if you want to define something
  local ok = pcall(builtin.git_files, opts)
  if not ok then
    builtin.find_files(opts)
  end
end

local function grep_current_file_type(func)
  local current_file_ext = vim.fn.expand('%:e')
  local additional_vimgrep_arguments = {}
  if current_file_ext ~= '' then
    additional_vimgrep_arguments = vim.list_extend(additional_vimgrep_arguments, {
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

vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<M-p>', builtin.oldfiles, {})
vim.keymap.set('n', '<C-g>', builtin.live_grep, {})
vim.keymap.set('n', '<M-g>', live_grep_current_file_type, {})
vim.keymap.set('n', '<leader>t*', grep_string_current_file_type, {})
vim.keymap.set('n', '<leader>*', builtin.grep_string, {})
vim.keymap.set('n', '<leader>tg', project_files, {})
vim.keymap.set('n', '<leader>tc', builtin.quickfix, {})
vim.keymap.set('n', '<leader>tq', builtin.command_history, {})
vim.keymap.set('n', '<leader>tl', builtin.loclist, {})
vim.keymap.set('n', '<leader>tr', builtin.registers, {})
vim.keymap.set('n', '<leader>tp', '<Cmd>Telescope repo list<CR>', {})
vim.keymap.set('n', '<leader>tP', function()
  require('telescope').extensions.projects.projects {}
end, {})
vim.keymap.set('n', '<leader>ty', '<Cmd>Telescope yank_history<CR>', {})
vim.keymap.set('n', '<leader>tb', builtin.buffers, {})
vim.keymap.set('n', '<leader>tf', builtin.current_buffer_fuzzy_find, {})
vim.keymap.set('n', '<leader>td', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>tS', '<Cmd>Telescope ultisnips ultisnips<CR>', {})
vim.keymap.set('n', '<leader>ts', function()
  require('telescope').extensions.possession.list()
end, {})
vim.keymap.set('n', '<leader>th', '<Cmd>Telescope hoogle<CR>', {})
vim.keymap.set('n', '<leader>tn', function()
  require('telescope-manix').search()
end, {})
vim.keymap.set('n', '<leader>n*', function()
  require('telescope-manix').search { cword = true }
end, {})
vim.keymap.set('n', '<leader>to', builtin.lsp_dynamic_workspace_symbols, {})
-- api.nvim_set_keymap('n', '<leader>to', '<Cmd>Telescope lsp_workspace_symbols<CR>', opts)

telescope.setup {
  defaults = {
    path_display = {
      'shorten',
    },
    layout_strategy = 'vertical',
    layout_config = {
      vertical = {
        width = 0.8,
        height = 0.9,
        prompt_position = 'bottom',
        preview_cutoff = 0,
      },
    },
    mappings = {
      i = {
        ['<C-q>'] = actions.send_to_qflist,
        ['<C-l>'] = actions.send_to_loclist,
      },
      n = {
        ['q'] = require('telescope.actions').close,
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
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    },
    ['ui-select'] = {
      themes.get_dropdown {},
    },
  },
}

telescope.load_extension('ht')
telescope.load_extension('hoogle')
telescope.load_extension('manix')
telescope.load_extension('repo')
telescope.load_extension('fzy_native')
telescope.load_extension('smart_history')
telescope.load_extension('cheat')
telescope.load_extension('yank_history')
telescope.load_extension('projects')
telescope.load_extension('ui-select')
