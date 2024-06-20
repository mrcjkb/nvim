if vim.g.vim_matchup_setup_done then
  return
end
vim.api.nvim_create_autocmd('BufReadPost', {
  once = true,
  group = vim.api.nvim_create_augroup('vim_matchup-setup', {}),
  callback = function()
    if vim.g.vim_matchup_setup_done then
      return
    end
    vim.g.vim_matchup_setup_done = true
    vim.cmd.packadd('vim-matchup')
  end,
})
