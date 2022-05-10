" ---------------------- tiko stuff ---------------------------
" Style current buffer
au FileType haskell command! BufTikoStyle :Dispatch! stylish-haskell % -c $HOME/git/tiko-backend/backend/cli/lint/stylish-haskell.yaml -i %
  
" Style current buffer after writing Haskell files
au FileType haskell
      \ au BufWritePost <buffer> :BufTikoStyle

nnoremap <leader>s :write \| BufTikoStyle<CR>
