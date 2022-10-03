local cmd = vim.cmd
local fn = vim.fn
local opt = vim.o

cmd 'syntax on'
cmd 'syntax enable'
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
opt.foldmethod = 'indent'  -- fold based on indent level 
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

vim.g.markdown_syntax_conceal = 0

-- Highlight terminal cursor
vim.api.nvim_set_hl(0, 'TermCursor', {link = 'Cursor',})
vim.api.nvim_set_hl(0, 'TermCursorNC', {bg='red', fg='white', ctermbg=1, ctermfg=15})

-- Prevent nested nvim instances
if fn.executable('nvr') then
  vim.fn.setenv('VISUAL', "nvr -cc split --remote-wait + 'set bufhidden=wipe'")
end

-- Set default shell
opt.shell = "fish"
