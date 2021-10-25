local cmp = require'cmp'
local lspkind = require('lspkind')
cmp.setup({
    formatting = {
      format = lspkind.cmp_format({
          with_text = true,
          menu = {
            buffer = "[buf]",
            nvim_lsp = "[LSP]",
            nvim_lua = "[api]",
            path = "[path]",
            ultisnips = "[snip]",
          },
        }),
    },
    snippet = {
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
      end,
    },
    mapping = {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<C-y>'] = cmp.mapping.confirm({ 
        behaviour = cmp.ConfirmBehavior.Insert,
        select = true 
      }), -- If you want to remove the default `<C-y>` mapping, You can specify `cmp.config.disable` value.
      ['<CR>'] = cmp.mapping.confirm({ 
        behaviour = cmp.ConfirmBehavior.Insert,
        select = true 
      }),
    },
    sources = cmp.config.sources({
        -- The insertion order appears to influence the priority of the sources
        { name = 'nvim_lua' },
        { name = 'nvim_lsp' },
        -- { name = 'vsnip' }, -- For vsnip users.
        -- { name = 'luasnip' }, -- For luasnip users.
        { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
        { name = 'buffer' , keyword_length = 5 },
        { name = 'path' },
      }),
    experimental = {
      native_menu = false,
      ghost_text = true,
    }
  })
