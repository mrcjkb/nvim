let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/.config/nvim
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +7 init.vim
badd +9 ./lua/init.lua
badd +1 ./lua/native-plugins.lua
badd +48 ./lua/settings.lua
badd +8 ./lua/autocommands.lua
badd +9 lua/dap-setup.lua
badd +312 lua/plugins.lua
badd +4 lua/keymaps.lua
badd +6 lua/commands.lua
badd +4 term://~/.config/nvim//5562:gw
argglobal
%argdel
tabnew +setlocal\ bufhidden=wipe
tabnew +setlocal\ bufhidden=wipe
tabrewind
edit init.vim
argglobal
balt lua/commands.lua
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=10
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 16 - ((15 * winheight(0) + 20) / 41)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 16
normal! 0
tabnext
edit lua/plugins.lua
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
balt ./lua/autocommands.lua
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=10
setlocal fml=1
setlocal fdn=20
setlocal fen
6
normal! zo
36
normal! zo
40
normal! zo
61
normal! zo
63
normal! zo
82
normal! zo
96
normal! zo
101
normal! zo
137
normal! zo
139
normal! zo
149
normal! zo
162
normal! zo
213
normal! zo
234
normal! zo
236
normal! zo
237
normal! zo
246
normal! zo
249
normal! zo
260
normal! zo
262
normal! zo
270
normal! zo
272
normal! zo
280
normal! zo
282
normal! zo
283
normal! zo
290
normal! zo
310
normal! zo
313
normal! zo
331
normal! zo
344
normal! zo
347
normal! zo
388
normal! zo
397
normal! zo
407
normal! zo
426
normal! zo
428
normal! zo
445
normal! zo
447
normal! zo
455
normal! zo
460
normal! zo
461
normal! zo
462
normal! zo
467
normal! zo
let s:l = 312 - ((21 * winheight(0) + 20) / 41)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 312
normal! 010|
tabnext
edit ./lua/init.lua
argglobal
balt lua/keymaps.lua
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=10
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 10 - ((9 * winheight(0) + 20) / 41)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 10
normal! 0
tabnext 2
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
let g:this_session = v:this_session
let g:this_obsession = v:this_session
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
