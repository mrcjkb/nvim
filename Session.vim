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
badd +570 lua/plugins.lua
badd +8 lua/telescope-config.lua
badd +1 ~/git/tiko-backend/argo-deployments/master/README.md
badd +0 fugitive:///home/mrcjk/.config/nvim/.git//
argglobal
%argdel
$argadd lua/plugins.lua
edit lua/plugins.lua
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
split
1wincmd k
wincmd w
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe '1resize ' . ((&lines * 20 + 22) / 44)
exe '2resize ' . ((&lines * 20 + 22) / 44)
argglobal
balt lua/telescope-config.lua
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=10
setlocal fml=1
setlocal fdn=20
setlocal fen
112
normal! zo
162
normal! zo
164
normal! zo
165
normal! zo
379
normal! zo
176
normal! zo
189
normal! zo
218
normal! zo
220
normal! zo
231
normal! zo
240
normal! zo
248
normal! zo
250
normal! zo
269
normal! zo
271
normal! zo
272
normal! zo
281
normal! zo
284
normal! zo
295
normal! zo
297
normal! zo
305
normal! zo
307
normal! zo
315
normal! zo
317
normal! zo
318
normal! zo
325
normal! zo
345
normal! zo
348
normal! zo
366
normal! zo
379
normal! zo
388
normal! zo
396
normal! zo
432
normal! zo
441
normal! zo
451
normal! zo
492
normal! zo
let s:l = 165 - ((16 * winheight(0) + 10) / 20)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 165
normal! 03|
lcd ~/.config/nvim
wincmd w
argglobal
if bufexists(fnamemodify("fugitive:///home/mrcjk/.config/nvim/.git//", ":p")) | buffer fugitive:///home/mrcjk/.config/nvim/.git// | else | edit fugitive:///home/mrcjk/.config/nvim/.git// | endif
if &buftype ==# 'terminal'
  silent file fugitive:///home/mrcjk/.config/nvim/.git//
endif
balt ~/.config/nvim/lua/telescope-config.lua
setlocal fdm=indent
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=10
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 1 - ((0 * winheight(0) + 10) / 20)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
lcd ~/.config/nvim
wincmd w
2wincmd w
exe '1resize ' . ((&lines * 20 + 22) / 44)
exe '2resize ' . ((&lines * 20 + 22) / 44)
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let &winminheight = s:save_winminheight
let &winminwidth = s:save_winminwidth
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
