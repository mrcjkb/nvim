local ls = require('luasnip')

-- expand current item or jump to next
vim.keymap.set({ 'i', 's' }, '<c-k>', function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

-- jump to previous item
vim.keymap.set({ 'i', 's' }, '<c-j>', function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

-- select within a list of options
vim.keymap.set('i', '<c-l>', function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true })

-- Source luasnips config (for snippet development)
vim.keymap.set('n', '<leader><leader>s', '<cmd>source ~/git/github/mrcjkb/nvim-config/lua/plugin/luasnip/init.lua')
