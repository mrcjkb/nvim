" Make Ranger replace netrw and be the file explorer
let g:rnvimr_ex_enable = 1
" Make Neovim wipe the buffers corresponding to the files deleted by Ranger
let g:rnvimr_enable_bw = 1

tnoremap <silent> <M-i> <C-\><C-n>:RnvimrResize<CR>
nnoremap <silent> <M-r> :RnvimrToggle<CR>
tnoremap <silent> <M-O> <C-\><C-n>:RnvimrToggle<CR>


" Map Rnvimr action
let g:rnvimr_action = {
            \ '<C-t>': 'NvimEdit tabedit',
            \ '<C-x>': 'NvimEdit split',
            \ '<C-v>': 'NvimEdit vsplit',
            \ 'gw': 'JumpNvimCwd',
            \ 'gf': 'AttachFile',
            \ 'yw': 'EmitRangerCwd'
            \ }


