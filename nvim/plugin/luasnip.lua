local ls = require('luasnip')

-- expand current item or jump to next
vim.keymap.set({ 'i', 's' }, '<c-j>', function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true, desc = '[luasnip] expand or jump' })

-- jump to previous item
vim.keymap.set({ 'i', 's' }, '<c-k>', function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true, desc = '[luasnip] jump' })

-- select within a list of options
vim.keymap.set('i', '<c-l>', function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true, desc = '[luasnip] change choice' })

-- Source luasnips config (for snippet development)
vim.keymap.set('n', '<leader><leader>s', function()
  vim.cmd.source('/home/mrcjk/git/github/mrcjkb/nvim/nvim/plugin/luasnip.lua')
end, { desc = '[luasnip-dev] source snippets' })

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
-- local dynamic = ls.dynamic_node
-- local func = ls.function_node
-- local indent = ls.indent_snippet_node
-- local fmt = require('luasnip.extras.fmt').fmt
-- local fmta = require('luasnip.extras.fmt').fmta
-- local rep = require('luasnip.extras').rep

-- NIX SNIPPETS

local nix_snippets = {}

local shellApp = s({
  trig = 'shellApp',
  descr = 'writeShellApplication',
}, {
  text('writeShellApplication {'),
  text { '', '  name = "' },
  insert(1),
  text('";'),
  choice(2, {
    sn(nil, {
      text { '', '  runtimeInputs = [', '    ' },
      insert(1),
      text { '', '  ];' },
    }),
    text { '', '  runtimeInputs = [];' },
  }),
  text { '', "  text = ''", '' },
  text('    '),
  insert(3),
  text { '', "  '';", '};' },
})
table.insert(nix_snippets, shellApp)

ls.add_snippets('nix', nix_snippets, { key = 'nix' })

-- HASKELL SNIPPETS

local haskell_snippets = require('haskell-snippets').all

--- QuasiQuote
local log = s({
  trig = 'log',
  dscr = 'Log quasiquote',
}, {
  text('[Log.'),
  choice(1, {
    text('e'),
    text('i'),
    text('d'),
    text('f'),
    text('t'),
  }),
  text('|'),
  insert(2),
  text('|'),
  text(']'),
})
table.insert(haskell_snippets, log)

ls.add_snippets('haskell', haskell_snippets, { key = 'haskell' })
