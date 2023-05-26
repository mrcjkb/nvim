local ls = require('luasnip')

-- expand current item or jump to next
vim.keymap.set({ 'i', 's' }, '<c-j>', function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

-- jump to previous item
vim.keymap.set({ 'i', 's' }, '<c-k>', function()
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
-- local func = ls.function_node
local dynamic = ls.dynamic_node
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

-- HASKELL SNIPPETS

local haskell_snippets = {}
local indentstr = '  '
local hs_lang = require('nvim-treesitter.parsers').ft_to_lang('haskell')

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

local function get_module_name_node()
  if #vim.lsp.get_active_clients { bufnr = 0 } > 0 then
    for _, lens in pairs(vim.lsp.codelens.get(0)) do
      local name = lens.command.title:match('module (.*) where')
      if name then
        return sn(nil, { text(name) })
      end
    end
  end
  return sn(nil, { insert(1) })
end

local mod = s({
  trig = 'mod',
  dscr = 'Module declaration',
}, {
  text('module '),
  dynamic(1, get_module_name_node),
  choice(2, {
    text(' () where'),
    sn(nil, {
      text { '', indentstr .. '( ' },
      insert(1),
      text { '', indentstr .. ') where' },
    }),
    sn(nil, {
      text { ' (main) where', '', 'main :: IO ()', 'main = ' },
      insert(1),
    }),
  }),
})
table.insert(haskell_snippets, mod)

--- Parses without injections
local function fast_parse(lang_tree)
  if lang_tree._valid then
    return lang_tree._trees
  end
  local parser = lang_tree._parser
  local old_trees = lang_tree._trees
  return parser:parse(old_trees[1], lang_tree._source)
end

local function get_qualified_name_node(args)
  local node_ref = args[1]
  local module_name = node_ref and #node_ref > 0 and node_ref[1]
  if not module_name then
    return sn(nil, { text('') })
  end
  local import_stmt = 'import qualified ' .. module_name
  local module_query = vim.treesitter.query.parse(hs_lang, '(module) @mod')
  local lang_tree = vim.treesitter.get_string_parser(import_stmt, hs_lang, { injections = { [hs_lang] = '' } })
  local root = fast_parse(lang_tree):root()
  local choices = { insert(1) }
  for _, match in module_query:iter_matches(root, import_stmt) do
    for _, node in ipairs(match) do
      local txt = vim.treesitter.get_node_text(node, import_stmt)
      table.insert(choices, 1, text(txt:sub(1, 1)))
      table.insert(choices, 1, text(txt))
    end
  end
  return sn(nil, {
    choice(1, choices),
  })
end

local qual = s({
  trig = 'qual',
  dscr = 'Qualified import',
}, {
  text('import qualified '),
  insert(1),
  text(' as '),
  dynamic(2, get_qualified_name_node, { 1 }),
})
table.insert(haskell_snippets, qual)

---@type function
local adt_constructor_choice

adt_constructor_choice = function()
  return sn(nil, {
    choice(1, {
      text(''),
      sn(nil, {
        text { '', indentstr .. '| ' },
        insert(1, 'Constructor'),
        dynamic(2, adt_constructor_choice),
      }),
    }),
  })
end

local adt = s({
  trig = 'adt',
  dscr = 'Algebraic data type',
}, {
  text('data '),
  insert(1, 'Type'),
  choice(2, {
    text { '', indentstr .. '= ' },
    sn(nil, {
      text(' '),
      insert(1, 'a'),
      text { '', indentstr .. '= ' },
    }),
  }),
  insert(3, 'Constructor'),
  text { '', indentstr .. '| ' },
  insert(4, 'Constructor'),
  dynamic(5, adt_constructor_choice),
})
table.insert(haskell_snippets, adt)

local newtype = s({
  trig = 'new',
  dscr = 'newtype',
}, {
  text('newtype '),
  insert(1, 'Type'),
  choice(2, {
    text(' = '),
    sn(nil, {
      text(' '),
      insert(1, 'a'),
      text(' = '),
    }),
  }),
  insert(3, 'Constructor'),
  text(' '),
  insert(4, 'Int'),
})
table.insert(haskell_snippets, newtype)

---@type function
local record_field_choice

record_field_choice = function()
  return sn(nil, {
    choice(1, {
      text { '', indentstr .. '}' },
      sn(nil, {
        text { '', indentstr .. ', ' },
        insert(1),
        text(' :: '),
        insert(2),
        dynamic(3, record_field_choice),
      }),
    }),
  })
end

local rec = s({
  trig = 'rec',
  dscr = 'Record',
}, {
  text('data '),
  insert(1, 'Type'),
  choice(2, {
    text { '', indentstr .. '= ' },
    sn(nil, {
      text(' '),
      insert(1, 'a'),
      text { '', indentstr .. '= ' },
    }),
  }),
  insert(3, 'Constructor'),
  text { '', indentstr .. '{ ' },
  insert(4),
  text(' :: '),
  insert(5),
  dynamic(6, record_field_choice),
  choice(7, {
    text(''),
    sn(nil, {
      text { '', indentstr .. 'deriving (' },
      insert(1),
      text(')'),
    }),
    sn(nil, {
      text { '', indentstr .. 'deriving ' },
      insert(1),
    }),
  }),
})
table.insert(haskell_snippets, rec)

local cls = s({
  trig = 'cls',
  dscr = 'Typeclass',
}, {
  text('class '),
  insert(1),
  text { ' where', indentstr },
  insert(2),
})
table.insert(haskell_snippets, cls)

local ins = s({
  trig = 'ins',
  dscr = 'Typeclass instance',
}, {
  text('instance '),
  insert(1, 'Class'),
  text(' '),
  insert(2, 'Type'),
  text { ' where', indentstr },
  insert(3),
})
table.insert(haskell_snippets, ins)

local constraint = s({
  trig = '=>',
  descr = 'Typeclass constraint',
}, {
  insert(1, 'Class'),
  text(' '),
  insert(2, 'a'),
  text(' => '),
  insert(3),
})
table.insert(haskell_snippets, constraint)

---@type function
local build_function_snippet
build_function_snippet = function(multiline, args, _, _, user_args)
  if not user_args then
    local name_arg = args[1]
    local function_name = name_arg and #name_arg > 0 and name_arg[1] or ''
    user_args = {
      name = function_name,
      arg_count = 0,
    }
  end
  table.insert(user_args, args[1])
  local choices = {}
  local end_snip = {
    insert(1),
    text { '', user_args.name },
  }
  local idx = 2
  if user_args.arg_count > 0 then
    for _ = 1, user_args.arg_count do
      table.insert(end_snip, text(' '))
      table.insert(end_snip, insert(idx, '_'))
      idx = idx + 1
    end
  end
  table.insert(end_snip, text(' = '))
  table.insert(end_snip, insert(idx, 'undefined'))
  table.insert(choices, sn(nil, end_snip))
  local function wrapper(a, p, os)
    -- XXX: For some reason, user_args is not passed down.
    local updated_user_args = {
      name = user_args.name,
      arg_count = user_args.arg_count + 1,
    }
    return build_function_snippet(multiline, a, p, os, updated_user_args)
  end
  table.insert(
    choices,
    sn(nil, {
      insert(1),
      multiline and text { '', indentstr .. '-> ' } or text(' -> '),
      dynamic(2, wrapper, nil),
    })
  )
  return sn(nil, {
    choice(1, choices),
  })
end

local function build_single_line_function_snippet(...)
  return build_function_snippet(false, ...)
end

local function build_multi_line_function_snippet(...)
  return build_function_snippet(true, ...)
end

local fun = s({
  trig = 'fn',
  dscr = 'Function and type signature',
}, {
  insert(1, 'someFunc'),
  text(' :: '),
  dynamic(2, build_single_line_function_snippet, { 1 }),
})
table.insert(haskell_snippets, fun)

local bigfun = s({
  trig = 'func',
  dscr = 'Function and type signature (multi-line)',
}, {
  insert(1, 'someFunc'),
  text { '', indentstr .. ':: ' },
  dynamic(2, build_multi_line_function_snippet, { 1 }),
})
table.insert(haskell_snippets, bigfun)

local lambda = s({
  trig = '\\',
  dscr = 'Lambda',
}, {
  text('\\'),
  insert(1, '_'),
  text(' -> '),
  insert(2),
})
table.insert(haskell_snippets, lambda)

local if_expr = s({
  trig = 'if',
  dscr = 'If expression (single line)',
}, {
  text('if '),
  insert(1),
  text(' then '),
  insert(2),
  text(' else '),
  insert(3),
})
table.insert(haskell_snippets, if_expr)

---@param mk_node function
---@param extra_indent boolean?
local function _indent_newline(mk_node, extra_indent, _, parent)
  extra_indent = extra_indent == nil or extra_indent
  local _, pos = pcall(function()
    -- This prints an error
    return parent:get_buf_position()
  end)
  -- local pos = parent:get_buf_position()
  local indent_count = pos[2]
  local indent_str = string.rep(' ', indent_count) .. (extra_indent and indentstr or '')
  return mk_node(indent_str)
end

local function indent_newline_text(txt, extra_indent)
  local function mk_node(indent_str)
    return sn(nil, { text { '', indent_str .. txt } })
  end
  return function(...)
    return _indent_newline(mk_node, extra_indent, ...)
  end
end

local function indent_newline_insert(txt, extra_indent)
  local function mk_node(indent_str)
    return sn(nil, {
      text { '', indent_str },
      insert(1, txt),
    })
  end
  return function(...)
    return _indent_newline(mk_node, extra_indent, ...)
  end
end

local if_expr_multiline = s({
  trig = 'iff',
  dscr = 'If expression (multi lines)',
}, {
  text('if '),
  insert(1),
  dynamic(2, indent_newline_text('then ')),
  insert(3),
  dynamic(4, indent_newline_text('else ')),
  insert(5),
})
table.insert(haskell_snippets, if_expr_multiline)

local case = s({
  trig = 'case',
  dscr = 'Case expression (pattern match)',
}, {
  text('case '),
  insert(1),
  text(' of'),
  dynamic(2, indent_newline_insert('_')),
  text(' -> '),
  insert(3),
  dynamic(4, indent_newline_insert('_')),
  text(' -> '),
  insert(5),
})
table.insert(haskell_snippets, case)

local lambdacase = s({
  trig = '\\case',
  dscr = 'Lambda (pattern match)',
}, {
  text('\\case'),
  dynamic(1, indent_newline_insert('_')),
  text(' -> '),
  insert(2),
  dynamic(3, indent_newline_insert('_')),
  text(' -> '),
  insert(4),
})
table.insert(haskell_snippets, lambdacase)

local qq = s({
  trig = 'qq',
  dscr = 'QuasiQuote',
}, {
  text('['),
  insert(1),
  text('|'),
  insert(2),
  text('|'),
  text(']'),
})
table.insert(haskell_snippets, qq)

local sql = s({
  trig = 'sql',
  dscr = 'postgres-simple sql QuasiQuote',
}, {
  text('[sql|'),
  dynamic(1, indent_newline_insert()),
  dynamic(2, indent_newline_text('|]', false)),
})
table.insert(haskell_snippets, sql)

ls.add_snippets('nix', nix_snippets, { key = 'nix' })
ls.add_snippets('haskell', haskell_snippets, { key = 'haskell' })
