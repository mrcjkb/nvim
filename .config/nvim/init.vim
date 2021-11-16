filetype plugin indent on
packadd cfilter
set hidden " Required to persist toggleterm sessions
syntax on
syntax enable
set nocompatible

" Enable true colour support
if has('termguicolors')
  set termguicolors
endif

" Search down into subfolders
set path+=**
set number
set relativenumber
set background=dark
set cursorline
" Enable tab-completion
set wildmenu
set wildmode=full
set lazyredraw
set showmatch " Highlight matching parentheses, etc
set incsearch
set hlsearch
set complete=.,w,b,u,t,i,kspell
runtime macros/matchit.vim

" On pressing tab, insert 2 spaces
set expandtab
" Show existing tab with 2 spaces width
set tabstop=2
set softtabstop=2
" When indenting with '>', use 2 spaces width
set shiftwidth=2
set foldenable
set foldlevelstart=10
set foldmethod=indent  " fold based on indent level 
set history=2000
"Increment numbers in decimal format
set nrformats-=octal
"Persist undos between sessions
set undofile
autocmd BufWritePre /tmp/* setlocal noundofile
"Split right and below
set splitright
set splitbelow

" Turn off search highlight by mapping :nohlsearch to space
nnoremap <leader><space> :nohlsearch<CR>

" Remap Y to yank till the end of the line (consistent with C and D)
nnoremap Y y$

" Terminal
nnoremap <leader>t :below terminal<CR>

" Buffer list navigation
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>

" Undo break points
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

" Moving text
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '>-2<CR>gv=gv
nnoremap <leader>j :m .+1<CR>==
inoremap <C-j> :m .+1<CR>==
inoremap <C-k> :m .-2<CR>==
nnoremap <leader>k :m .-2<CR>==

" Quickfix list navigation
function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction
nnoremap <silent> <C-c> :call ToggleQuickFix()<CR>
" Make cnext, cprev, lnext, lprev cycle
command! Cnext try | cnext | catch | cfirst | catch | endtry
command! Cprev try | cprev | catch | clast | catch | endtry
command! Lnext try | lnext | catch | lfirst | catch | endtry
command! Lprev try | lprev | catch | llast | catch | endtry
command! DeleteOtherBufs %bd|e#
nnoremap <silent> [c :Cprev<CR>
nnoremap <silent> ]c :Cnext<CR>
nnoremap <silent> [C :Cfirst<CR>
nnoremap <silent> ]C :Clast<CR>
" Location list navigation
nnoremap <silent> <C-l> :lopen<CR>
nnoremap <silent> [l :Lprev<CR>
nnoremap <silent> ]l :Lnext<CR>
nnoremap <silent> [L :Lfirst<CR>
nnoremap <silent> ]L :Llast<CR>

" Resize split windows with leader +/-
nnoremap <silent> <leader>+ :exe "vertical resize " . (winwidth(0) * 3/2)<CR>
nnoremap <silent> <leader>- :exe "vertical resize " . (winwidth(0) * 2/3)<CR>
nnoremap <silent> <space>+ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <space>- :exe "resize " . (winheight(0) * 2/3)<CR>

" Shortcut for expanding to current buffer's directory
cnoremap <expr> %% getcmdtype() == ':' ? expand("%:h')'/' : '%%' 


if has('nvim')
  "Remap Esc to switch to normal mode and Ctrl-Esc to pass Esc to terminal
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-v><Esc> <Esc>
endif

" Syntactic sugar for gng 'gw' command
command! -nargs=* Gradle split | resize 10 | terminal gw <args>

" Pandoc shortcut
command! -nargs=* Pd split | resize 10 | terminal pandoc % -f markdown-implicit_figures -s -o <args>


" Plugins
lua require('plugins')

" vim-table-mode pandoc compatibility configuration
let g:table_mode_corner='+'
let g:table_mode_corner_corner='+'
let g:table_mode_header_fillchar='='


let g:markdown_syntax_conceal = 0
" Align GitHub-flavored Markdown tables
au FileType markdown vmap <Leader><Bslash> :EasyAlign*<Bar><Enter>

"vim-wordmotion
let g:wordmotion_mappings = {
\ 'w' : '<M-w>',
\ 'b' : '<M-b>',
\ 'e' : '<M-e>',
\ 'ge' : 'g<M-e>',
\ 'aw' : 'a<M-w>',
\ 'iw' : 'i<M-w>',
\ '<C-R><C-W>' : '<C-R><M-w>'
\ }
" Sneak
let g:sneak#label = 1
let g:sneak#prompt = '🔍'
" Replace f and F with Sneak
map <M-f> <Plug>Sneak_s
map <M-F> <Plug>Sneak_S

" colorscheme codedark
let g:material_theme_style = 'darker'
let g:material_terminal_italics = 1
colorscheme material


let g:polyglot_disabled = ['java']

let g:neomake_java_gradle_executable = 'gw'

let test#strategy = "neovim"
let test#java#runner = 'gradletest'

if has('nvim')
  "Highlight terminal cursor
  highlight! link TermCursor Cursor
  highlight! TermCursorNC guibg=red guifg=white ctermbg=1 ctermfg=15
  "Prevent nested nvim instances
  if executable('nvr')
    let $VISUAL="nvr -cc split --remote-wait + 'set bufhidden=wipe'"
  endif
endif

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" -------------------------- Tree-Sitter --------------------------

lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true
  },
  rainbow = {
    enable = true,
    extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
    max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
  }
}
EOF

" completion-nvim
" autocmd BufEnter * lua require'completion'.on_attach()
let g:completion_enable_snippet = 'UltiSnips'
let g:completion_auto_change_source = 1
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy', 'all']
let g:completion_matching_smart_case = 1
let g:completion_trigger_on_delete = 1
" let g:completion_sorting = "none"
let g:UltiSnipsExpandTrigger="<tab>"

" \{'complete_items': ['lsp', 'snippet', 'tabnine']},
" \{'mode': 'spel'}, -> Disabled, because it fails when spell check is not
" enabled
let g:completion_chain_complete_list = [
    \{'complete_items': ['lsp', 'snippet']},
    \{'complete_items': ['snippet']},
    \{'TelescopePrompt' : [ ]},
    \{'mode': '<c-p>'},
    \{'mode': '<c-n>'},
    \{'mode': 'defs'},
    \{'mode': 'file'},
    \{'mode': 'line'},
    \{'mode': 'dict'},
\]


" imap <M-j> <Plug>(completion_next_source)
" imap <M-k> <Plug>(completion_prev_source)

" Set completeopt to have a better completion experience
" set completeopt=menuone,noinsert,noselect
set completeopt=menuone,noselect
" Avoid showing message extra message when using completion
"set shortmess+=c

" UltiSnips
let g:UltiSnipsSnippetDirectories=["UltiSnips", "ultisnips"]

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"



" ------------------- Snippets.nvim ---------------------------
lua require'snippets'.use_suggested_mappings()
" This variant will set up the mappings only for the *CURRENT* buffer.
" There are only two keybindings specified by the suggested keymappings, which is <C-k> and <C-j>
" They are exactly equivalent to:
" <c-k> will either expand the current snippet at the word or try to jump to
" the next position for the snippet.
inoremap <c-k> <cmd>lua return require'snippets'.expand_or_advance(1)<CR>
" <c-j> will jump backwards to the previous field.
" If you jump before the first field, it will cancel the snippet.
inoremap <c-j> <cmd>lua return require'snippets'.advance_snippet(-1)<CR>
" ------------------- Snippets.nvim ---------------------------
lua require('colorizer').setup()
" External configs
source $VIMCONFIG/vimscript/rnvimr.vim
source $VIMCONFIG/vimscript/coc.vim
source $VIMCONFIG/vimscript/quickscope-config.vim
lua require('lsp-overrides').setup()
lua require('lspconfig-setup')
lua require('dap-setup')
lua require('lsputils-config')
lua require('telescope-config')
lua require('treesitter-config')
lua require('completion-config')
lua require('lualine-setup')
lua require('toggleterm-setup')
lua require('twilight-config')
