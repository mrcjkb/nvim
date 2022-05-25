" ---------------------- tiko stuff ---------------------------

" Style current buffer
au BufNewFile,BufRead $HOME/git/tiko-backend/backend/*
      \ au FileType haskell command! BufTikoStyle :Dispatch! stylish-haskell % -c $HOME/git/tiko-backend/backend/cli/lint/stylish-haskell.yaml -i %
  
" Style current buffer after writing Haskell files
au BufNewFile,BufRead $HOME/git/tiko-backend/backend/*
      \ au FileType haskell 
      \ au BufWritePost <buffer> :BufTikoStyle

nnoremap <leader>s :write \| BufTikoStyle<CR>

" let g:test#haskell#stacktest#file_pattern = '\v^(.*spec.*|.*test.*)\c\.hs$'
