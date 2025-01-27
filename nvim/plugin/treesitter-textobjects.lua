if vim.g.nvim_treesitter_textobjects_setup_done then
  return
end
vim.api.nvim_create_autocmd('FileType', {
  once = true,
  pattern = '*',
  group = vim.api.nvim_create_augroup('nvim_treesitter_textobjects-setup', {}),
  callback = function()
    if vim.g.nvim_treesitter_textobjects_setup_done then
      return
    end
    vim.g.nvim_treesitter_textobjects_setup_done = true
    require('nvim-treesitter-textobjects').setup {
      select = {
        -- Automatically jump forward to textobjects, similar to targets.vim
        lookahead = true,
        selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          ['@function.outer'] = 'V', -- linewise
          ['@class.outer'] = '<c-v>', -- blockwise
        },
      },
      move = {
        -- whether to set jumps in the jumplist
        set_jumps = true,
      },
    }

    -- select
    vim.keymap.set({ 'x', 'o' }, 'af', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects')
    end)
    vim.keymap.set({ 'x', 'o' }, 'if', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects')
    end)
    vim.keymap.set({ 'x', 'o' }, 'ac', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects')
    end)
    vim.keymap.set({ 'x', 'o' }, 'ic', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects')
    end)
    vim.keymap.set({ 'x', 'o' }, 'as', function()
      require('nvim-treesitter-textobjects.select').select_textobject('@local.scope', 'locals')
    end)

    -- swap
    vim.keymap.set('n', '<leader>a', function()
      require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner')
    end)
    vim.keymap.set('n', '<leader>A', function()
      require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.outer')
    end)

    -- move
    vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
      require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
    end)
    vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
      require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
    end)
    vim.keymap.set({ 'n', 'x', 'o' }, ']p', function()
      require('nvim-treesitter-textobjects.move').goto_next_start('@parameter.outer', 'textobjects')
    end)
    vim.keymap.set({ 'n', 'x', 'o' }, ']P', function()
      require('nvim-treesitter-textobjects.move').goto_next_end('@parameter.outer', 'textobjects')
    end)
    vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
      require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
    end)
    vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
      require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects')
    end)
    vim.keymap.set({ 'n', 'x', 'o' }, '[p', function()
      require('nvim-treesitter-textobjects.move').goto_previous_start('@parameter.outer', 'textobjects')
    end)
    vim.keymap.set({ 'n', 'x', 'o' }, '[P', function()
      require('nvim-treesitter-textobjects.move').goto_previous_end('@parameter.outer', 'textobjects')
    end)
  end,
})
