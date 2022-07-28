lua require('init')  -- TODO: Replace with init.lua


" Shortcut for expanding to current buffer's directory
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%' 

"Highlight terminal cursor
highlight! link TermCursor Cursor
highlight! TermCursorNC guibg=red guifg=white ctermbg=1 ctermfg=15

"Prevent nested nvim instances
if executable('nvr')
  let $VISUAL="nvr -cc split --remote-wait + 'set bufhidden=wipe'"
endif

" External configs
source $VIMCONFIG/vimscript/quickscope-config.vim
source $VIMCONFIG/vimscript/tiko.vim

