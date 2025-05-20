local cmd = vim.cmd
local opt = vim.opt
local keymap = vim.keymap
local g = vim.g

opt.compatible = false

-- Enable true colour support
opt.termguicolors = true

-- Search down into subfolders
opt.path = vim.o.path .. '**'
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.lazyredraw = true
opt.showmatch = true -- Highlight matching parentheses, etc
opt.incsearch = true
opt.hlsearch = true

opt.spell = true
opt.spelllang = 'en,de_ch'

-- On pressing tab, insert spaces
opt.expandtab = true
-- Show existing tab with 2 spaces width
opt.tabstop = 2
opt.softtabstop = 2
-- When indenting with '>', use 2 spaces width
opt.shiftwidth = 2
opt.foldenable = true
opt.foldlevelstart = 10
-- opt.foldmethod = 'indent' -- fold based on indent level
opt.history = 2000
-- Increment numbers in decimal and hexadecimal formats
opt.nrformats = 'bin,hex' -- 'octal'
-- Persist undos between sessions
opt.undofile = true
-- Split right and below
opt.splitright = true
opt.splitbelow = true
-- Global statusline
-- opt.laststatus = 3 -- managed by lualine
-- Hide command line unless typing a command or printing a message
opt.cmdheight = 0

-- Keep cursor in the middle of the pane while scrolling
-- opt.scrolloff = 10000

opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

opt.completeopt = 'menu,menuone,noinsert,fuzzy,popup,noselect'

g.markdown_syntax_conceal = 0

-- See https://github.com/hrsh7th/nvim-compe/issues/286#issuecomment-805140394
g.omni_sql_default_compl_type = 'syntax'

-- Set default shell
if vim.fn.executable('nu') == 1 then
  opt.shell = 'nu'
elseif vim.fn.executable('zsh') == 1 then
  opt.shell = 'zsh'
end

opt.timeout = true
opt.timeoutlen = 300

opt.tags:append { '.tags' }

local function format_diagnostic(prefix, diagnostic)
  local formatted_message = diagnostic
    .message
    -- Replace any sequence of whitespace characters (including newlines) with a single space
    :gsub('%s+', ' ')
  return string.format(prefix .. ' %s', formatted_message)
end

local virtual_text_config = {
  prefix = '',
  format = function(diagnostic)
    local severity = diagnostic.severity
    if severity == vim.diagnostic.severity.ERROR then
      return format_diagnostic('󰅚', diagnostic)
    end
    if severity == vim.diagnostic.severity.WARN then
      return format_diagnostic('⚠', diagnostic)
    end
    if severity == vim.diagnostic.severity.INFO then
      return format_diagnostic('ⓘ', diagnostic)
    end
    if severity == vim.diagnostic.severity.HINT then
      return format_diagnostic('󰌶', diagnostic)
    end
    return format_diagnostic('■', diagnostic)
  end,
}

local diagnostic_config = {
  virtual_text = virtual_text_config,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚',
      [vim.diagnostic.severity.WARN] = '⚠',
      [vim.diagnostic.severity.INFO] = 'ⓘ',
      [vim.diagnostic.severity.HINT] = '󰌶',
    },
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'if_many',
    header = '',
    prefix = '',
  },
}

vim.diagnostic.config(diagnostic_config)

---@param direction 'forward' | 'backward'
local function cycle_diagnostic_modes(direction)
  local current_config = vim.diagnostic.config() or diagnostic_config
  local modes = {
    { virtual_text = virtual_text_config, virtual_lines = false },
    { virtual_text = false, virtual_lines = true },
    { virtual_text = false, virtual_lines = false },
  }

  local current_mode_index
  for i, mode in ipairs(modes) do
    if
      (
        (type(current_config.virtual_text) == 'table' and mode.virtual_text == virtual_text_config)
        or (current_config.virtual_text == mode.virtual_text)
      ) and (current_config.virtual_lines == mode.virtual_lines)
    then
      current_mode_index = i
      break
    end
  end
  local next_mode_index
  if direction == 'forward' then
    next_mode_index = (current_mode_index % #modes) + 1
  else
    next_mode_index = (current_mode_index - 2 + #modes) % #modes + 1
  end
  vim.diagnostic.config(vim.tbl_extend('force', current_config, modes[next_mode_index]))
end

vim.keymap.set('n', '<space>d]', function()
  cycle_diagnostic_modes('forward')
end, { noremap = true, silent = true })

vim.keymap.set('n', '<space>d[', function()
  cycle_diagnostic_modes('backward')
end, { noremap = true, silent = true })

vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('DisableNewLineAutoCommentString', {}),
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions - { 'c', 'r', 'o' }
  end,
})

g.editorconfig = true

vim.opt.colorcolumn = '100'

-- Native plugins
cmd.filetype('plugin', 'indent', 'on')
cmd.packadd('cfilter')

-- Disable builtin plugins
g.loaded_gzip = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1

g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_2html_plugin = 1

g.loaded_matchit = 1
g.loaded_matchparen = 1
g.loaded_logiPat = 1
g.loaded_rrhelper = 1

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_netrwSettings = 1
g.loaded_netrwFileHandlers = 1

vim.cmd([[
  set sessionoptions-=buffers
]])

-- Plugin settings
local keymap_opts = { noremap = true, silent = true }

---@return haskell-tools.Opts
g.haskell_tools = function()
  ---@type haskell-tools.Opts
  local ht_opts = {
    tools = {
      repl = {
        auto_focus = false,
      },
      codeLens = {
        autoRefresh = false,
      },
      definition = {
        hoogle_signature_fallback = true,
      },
    },
    hls = {
      -- for hls development
      -- cmd = { 'cabal', 'run', 'haskell-language-server' },
      on_attach = function(_, bufnr, ht)
        local desc = function(description)
          return vim.tbl_extend('keep', keymap_opts, { buffer = bufnr, desc = description })
        end
        keymap.set('n', 'gh', ht.hoogle.hoogle_signature, desc('haskell: [h]oogle signature search'))
        keymap.set('n', '<space>tg', function()
          vim.cmd.Telescope { 'ht', 'package_grep' }
        end, desc('haskell: [t]elescope package [g]rep'))
        keymap.set('n', '<space>th', function()
          vim.cmd.Telescope { 'ht', 'package_hsgrep' }
        end, desc('haskell: [t]elescope package grep [h]askell files'))
        keymap.set('n', '<space>tf', function()
          vim.cmd.Telescope { 'ht', 'package_files' }
        end, desc('haskell: [t]elescope package [f]iles'))
        keymap.set('n', '<space>ea', ht.lsp.buf_eval_all, desc('haskell: [e]valuate [a]ll'))
      end,
      default_settings = {
        haskell = {
          checkProject = false, -- PERF: don't check the entire project on initial load
          formattingProvider = 'fourmolu',
          maxCompletions = 30,
          plugin = {
            semanticTokens = {
              globalOn = true,
            },
            rename = {
              config = {
                diff = true, -- (experimental) rename across modules
              },
            },
          },
        },
      },
    },
  }
  return ht_opts
end

---@return rustaceanvim.Opts
g.rustaceanvim = function()
  ---@type rustaceanvim.Opts
  local rustacean_opts = {
    server = {
      default_settings = {
        ['rust-analyzer'] = {
          cargo = {
            loadOutDirsFromCheck = true,
            runBuildScripts = true,
          },
          procMacro = {
            enable = true,
          },
          inlayHints = {
            lifetimeElisionHints = {
              enable = true,
              useParameterNames = true,
            },
          },
        },
      },
    },
  }
  return rustacean_opts
end

-- nvim-ts-context-commentstring
g.skip_ts_context_commentstring_module = true
