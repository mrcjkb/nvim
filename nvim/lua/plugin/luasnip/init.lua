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
vim.keymap.set('n', '<leader><leader>s', function()
  vim.cmd([[
      source /home/mrcjk/git/github/mrcjkb/nvim-config/nvim/lua/plugin/luasnip/init.lua
    ]])
end)

ls.setup {
  history = true,
  -- Update more often, :h events for more info.
  update_events = 'TextChanged,TextChangedI',
  -- Snippets aren't automatically removed if their text is deleted.
  -- `delete_check_events` determines on which events (:h events) a check for
  -- deleted snippets is performed.
  -- This can be especially useful when `history` is enabled.
  delete_check_events = 'TextChanged',
  -- treesitter-hl has 100, use something higher (default is 200).
  ext_base_prio = 300,
  -- Use treesitter to determine filetype - useful for treesitter injections
  ft_func = require('luasnip.extras.filetype_functions').from_cursor_pos,
}

-- local ls = require('luasnip')
local s = ls.snippet
local sn = ls.snippet_node
local text = ls.text_node
local insert = ls.insert_node
local choice = ls.choice_node
-- local f = ls.function_node
-- local d = ls.dynamic_node
-- local fmt = require('luasnip.extras.fmt').fmt
-- local fmta = require('luasnip.extras.fmt').fmta
-- local rep = require('luasnip.extras').rep

local haskell_snippets = {}

local pragma = s({
  trig = 'prag',
  dscr = 'Compiler pragma',
}, {
  text('{-# '),
  choice(1, {
    sn(nil, {
      insert(1),
      text(' #-}'),
    }),
    sn(nil, {
      text('LANGUAGE '),
      insert(1),
      text(' #-}'),
    }),
    sn(nil, {
      text('OPTIONS_GHC '),
      insert(1),
      text(' #-}'),
    }),
    sn(nil, {
      text('OPTIONS_GHC -F -pgmF '),
      insert(1),
      text(' #-}'),
    }),
    sn(nil, {
      text('INLINE '),
      insert(1),
      text(' #-}'),
    }),
    sn(nil, {
      text('INLINABLE '),
      insert(1),
      text(' #-}'),
    }),
    sn(nil, {
      text('NOINLINE '),
      insert(1),
      text(' #-}'),
    }),
  }),
})
table.insert(haskell_snippets, pragma)

local language_pragma = s({
  trig = 'lang',
  dscr = 'LANGUAGE pragma',
}, {
  text('{-# LANGUAGE '),
  choice(1, {
    insert(1),
    text('ScopedTypeVariables'),
    text('RecordWildCards'),
    text('LamdaCase'),
    text('QuasiQuotes'),
    text('ViewPatterns'),
    text('DerivingVia'),
    text('DeriveAnyClass'),
    text('DeriveGeneric'),
    text('MultiParamTypeClasses'),
    text('TypeFamilies'),
    text('DataKinds'),
    text('OverloadedLists'),
  }),
  text(' #-}'),
})
table.insert(haskell_snippets, language_pragma)

local discover_pragma = s({
  trig = 'discover',
  dscr = 'hspec/sydtest discover GHC option',
}, {
  text('{-# OPTIONS_GHC -F -pgmF '),
  choice(1, {
    text('hspec'),
    text('sydtest'),
  }),
  text('-discover -optF --module-name='),
  insert(2, 'Spec'),
  text(' #-}'),
})
table.insert(haskell_snippets, discover_pragma)

local nowarn_pragma = s({
  trig = 'nowarn',
  dscr = 'GHC option to disable warnings',
}, {
  text('{-# OPTIONS_GHC -fno-warn-'),
  choice(1, {
    text('orphans'),
    text('unused-binds'),
    text('unused-matches'),
    text('unused-imports'),
    text('incomplete-patterns'),
  }),
  text(' #-}'),
})
table.insert(haskell_snippets, nowarn_pragma)

ls.add_snippets('haskell', haskell_snippets, { key = 'haskell' })
