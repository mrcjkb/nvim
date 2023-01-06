local cmd = vim.cmd

cmd('filetype plugin indent on')
cmd('packadd cfilter')
cmd('runtime macros/matchit.vim')
