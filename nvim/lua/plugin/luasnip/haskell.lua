local ls = require('luasnip')
local s = ls.snippet
-- local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
-- local f = ls.function_node
-- local d = ls.dynamic_node
-- local fmt = require('luasnip.extras.fmt').fmt
-- local fmta = require('luasnip.extras.fmt').fmta
-- local rep = require('luasnip.extras').rep

local haskell_snippets = {}

local pragma = s({
  trig = 'pragma',
  dscr = 'Compiler pragma',
}, {
  t('{-# ', i(1), ' #-}'),
})
table.insert(haskell_snippets, pragma)

return haskell_snippets
