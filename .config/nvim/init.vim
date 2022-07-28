lua require('init') 

" Make cnext, cprev, lnext, lprev cycle
command! Cnext try | cnext | catch | cfirst | catch | endtry
command! Cprev try | cprev | catch | clast | catch | endtry
command! Lnext try | lnext | catch | lfirst | catch | endtry
command! Lprev try | lprev | catch | llast | catch | endtry
command! DeleteOtherBufs %bd|e#
command! Q :bd % <CR> "Delete current buffer
" command! Q! :bd! % <CR> "Delete current buffer (force)
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
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%' 


"Remap Esc to switch to normal mode and Ctrl-Esc to pass Esc to terminal
tnoremap <Esc> <C-\><C-n>
tnoremap <C-v><Esc> <Esc>

" Syntactic sugar for gng 'gw' command
command! -nargs=* Gradle split | resize 10 | terminal gw <args>

" Pandoc shortcut
command! -nargs=* Pd split | resize 10 | terminal pandoc % -f markdown-implicit_figures -s -o <args>

" Use Alt as prefix for word motion mappings
let g:wordmotion_mappings = {
  \ 'w' : '<M-w>',
  \ 'b' : '<M-b>',
  \ 'e' : '<M-e>',
  \ 'ge' : 'g<M-e>',
  \ 'aw' : 'a<M-w>',
  \ 'iw' : 'i<M-w>',
  \ '<C-R><C-W>' : '<C-R><M-w>'
\ }


let g:markdown_syntax_conceal = 0
" Align GitHub-flavored Markdown tables
au FileType markdown vmap <Leader><Bslash> :EasyAlign*<Bar><Enter>

"Highlight terminal cursor
highlight! link TermCursor Cursor
highlight! TermCursorNC guibg=red guifg=white ctermbg=1 ctermfg=15
"Prevent nested nvim instances
if executable('nvr')
  let $VISUAL="nvr -cc split --remote-wait + 'set bufhidden=wipe'"
endif

set completeopt=menu,menuone,noselect " Recommended by nvim-cmp
" Avoid showing message extra message when using completion
"set shortmess+=c


" Plugins
lua require('plugins')


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
" source $VIMCONFIG/vimscript/coc.vim
source $VIMCONFIG/vimscript/quickscope-config.vim
source $VIMCONFIG/vimscript/tiko.vim

