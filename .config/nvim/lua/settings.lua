local cmd = vim.cmd
local fn = vim.fn

cmd 'syntax on'
cmd 'syntax enable'
cmd 'set nocompatible'

-- Enable true colour support
if fn.has('termguicolors') then
  cmd 'set termguicolors'
end

-- Search down into subfolders
cmd 'set path+=**'
cmd 'set number'
cmd 'set relativenumber'
cmd 'set cursorline'
-- Enable tab-completion
cmd 'set wildmenu'
cmd 'set wildmode=full'
cmd 'set lazyredraw'
cmd 'set showmatch' -- Highlight matching parentheses, etc
cmd 'set incsearch'
cmd 'set hlsearch'
cmd 'set complete=.,w,b,u,t,i,kspell'

-- On pressing tab, insert 2 spaces
cmd 'set expandtab'
-- Show existing tab with 2 spaces width
cmd 'set tabstop=2'
cmd 'set softtabstop=2'
-- When indenting with '>', use 2 spaces width
cmd 'set shiftwidth=2'
cmd 'set foldenable'
cmd 'set foldlevelstart=10'
cmd 'set foldmethod=indent'  -- fold based on indent level 
cmd 'set history=2000'
-- Increment numbers in decimal format
cmd 'set nrformats-=octal'
-- Persist undos between sessions
cmd 'set undofile'
-- Split right and below
cmd 'set splitright'
cmd 'set splitbelow'
-- Global statusline
cmd 'set laststatus=3'

vim.g['markdown_syntax_conceal'] = 0

-- Highlight terminal cursor
vim.highlight.link('TermCursor', 'Cursor')
vim.highlight.create('TermCursorNC', {guibg='red', guifg='white', ctermbg=1, ctermfg=15})

-- Prevent nested nvim instances
if fn.executable('nvr') then
  vim.fn.setenv('VISUAL', "nvr -cc split --remote-wait + 'set bufhidden=wipe'")
end
