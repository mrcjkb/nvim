local cmd = vim.cmd
local fn = vim.fn
local opt = vim.o

cmd('syntax on')
cmd('syntax enable')
opt.compatible = false

-- Enable true colour support
if fn.has('termguicolors') then
  opt.termguicolors = true
end

-- Search down into subfolders
opt.path = vim.o.path .. '**'
opt.number = true
opt.relativenumber = true
opt.cursorline = true
-- Enable tab-completion
-- opt.wildmenu = true
-- opt.wildmode = 'full'
-- opt.complete = '.,w,b,u,t,i,kspell'
opt.lazyredraw = true
opt.showmatch = true -- Highlight matching parentheses, etc
opt.incsearch = true
opt.hlsearch = true

-- On pressing tab, insert spaces
opt.expandtab = true
-- Show existing tab with 2 spaces width
opt.tabstop = 2
opt.softtabstop = 2
-- When indenting with '>', use 2 spaces width
opt.shiftwidth = 2
opt.foldenable = true
opt.foldlevelstart = 10
opt.foldmethod = 'indent' -- fold based on indent level
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
-- Workaround to show macro recording indicator
local cmdheightaugroup = vim.api.nvim_create_augroup('cmdheight', { clear = true })
vim.api.nvim_create_autocmd('RecordingEnter', {
  group = cmdheightaugroup,
  callback = function()
    opt.cmdheight = 1
  end,
})
vim.api.nvim_create_autocmd('RecordingLeave', {
  group = cmdheightaugroup,
  callback = function()
    opt.cmdheight = 0
  end,
})

vim.g.markdown_syntax_conceal = 0

opt.updatetime = 100

-- Set default shell
opt.shell = 'fish'

local function prefix_diagnostic(prefix, diagnostic)
  return string.format(prefix .. ' %s', diagnostic.message)
end

local sign = function(opts)
  fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = '',
  })
end
sign { name = 'DiagnosticSignError', text = '' }
sign { name = 'DiagnosticSignWarn', text = '⚠' }
sign { name = 'DiagnosticSignInfo', text = 'ⓘ' }
sign { name = 'DiagnosticSignHint', text = '' }

vim.diagnostic.config {
  virtual_text = {
    prefix = '',
    format = function(diagnostic)
      local severity = diagnostic.severity
      if severity == vim.diagnostic.severity.ERROR then
        return prefix_diagnostic('', diagnostic)
      end
      if severity == vim.diagnostic.severity.WARN then
        return prefix_diagnostic('⚠', diagnostic)
      end
      if severity == vim.diagnostic.severity.INFO then
        return prefix_diagnostic('ⓘ', diagnostic)
      end
      if severity == vim.diagnostic.severity.HINT then
        return prefix_diagnostic('', diagnostic)
      end
      return prefix_diagnostic('■', diagnostic)
    end,
  },
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
}
