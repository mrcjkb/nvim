if vim.g.gitlinker_setup_done then
  return
end
vim.api.nvim_create_autocmd('BufWinEnter', {
  once = true,
  group = vim.api.nvim_create_augroup('gitlinker-setup', {}),
  callback = function()
    if vim.g.gitlinker_setup_done then
      return
    end
    vim.g.gitlinker_setup_done = true
    local gitlinker = require('gitlinker')

    ---@param dest string
    local function mk_gitlab_internal_router(dest)
      return 'https://gitlab.internal.tiko.ch/'
        .. '{_A.ORG}/'
        .. '{_A.REPO}/blob/'
        .. dest
        .. '{_A.FILE}'
        .. '#L{_A.LSTART}'
        .. "{(_A.LEND > _A.LSTART and ('-L' .. _A.LEND) or '')}"
    end

    gitlinker.setup {
      router = {
        browse = {
          ['^gitlab.internal.tiko%.ch'] = mk_gitlab_internal_router('{_A.REV}/'),
        },
        blame = {
          ['^gitlab.internal.tiko%.ch'] = mk_gitlab_internal_router('{_A.REPO}/blame/{_A.REV}/'),
        },
        default_branch = {
          ['^gitlab.internal.tiko%.ch'] = mk_gitlab_internal_router('{_A.DEFAULT_BRANCH}/'),
        },
        current_branch = {
          ['^gitlab.internal.tiko%.ch'] = mk_gitlab_internal_router('{_A.CURRENT_BRANCH}/'),
        },
      },
    }

    vim.keymap.set({ 'n', 'v' }, '<leader>gbb', function()
      vim.cmd.GitLink { bang = true }
    end, { silent = true, desc = '[g]it: open in [bb]rowser' })

    vim.keymap.set('n', '<leader>gBc', function()
      vim.cmd.GitLink { 'current_branch', bang = true }
    end, { silent = true, desc = '[g]it: open in [B]rowser ([c]urrent branch)' })

    vim.keymap.set('n', '<leader>gBd', function()
      vim.cmd.GitLink { 'default_branch', bang = true }
    end, { silent = true, desc = '[g]it: open in [B]rowser ([d]efault branch)' })
  end,
})
