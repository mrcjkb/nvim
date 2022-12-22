local cmp = require('cmp')
local lspkind = require('lspkind')
cmp.setup {
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  formatting = {
    format = lspkind.cmp_format {
      mode = 'symbol_text',
      with_text = true,
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

      menu = {
        buffer = '[BUF]',
        nvim_lsp = '[LSP]',
        nvim_lua = '[API]',
        path = '[PATH]',
        luasnip = '[SNIP]',
        ultisnips = '[ULTISNIP]',
        vsnip = '[VSNIP]',
        rg = '[RG]',
        cmdline = '[CMD]',
        cmp_git = '[GIT]',
      },
    },
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      vim.fn['UltiSnips#Anon'](args.body) -- For `ultisnips` users.
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-Space>'] = cmp.mapping.complete(),
    -- toggle completion
    ['<C-e>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.close()
        fallback()
      else
        cmp.complete()
      end
    end),
    ['<C-y>'] = cmp.mapping.confirm {
      select = true,
    }, -- If you want to remove the default `<C-y>` mapping, You can specify `cmp.config.disable` value.
  },
  sources = cmp.config.sources {
    -- The insertion order appears to influence the priority of the sources
    { name = 'omni' },
    { name = 'nvim_lua' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'luasnip' }, -- For luasnip users.
    { name = 'ultisnips' }, -- For ultisnips users.
    { name = 'rg', keyword_length = 3 },
    { name = 'buffer', keyword_length = 3 },
    { name = 'path' },
    -- { name = 'buffer-lines', keyword_length = 3 },
  },
  enabled = function()
    return vim.api.nvim_buf_get_option(0, 'buftype') ~= 'prompt' or require('cmp_dap').is_dap_buffer()
  end,
  experimental = {
    native_menu = false,
    ghost_text = true,
  },
}

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources {
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    { name = 'conventionalcommits' },
    { name = 'buffer' },
  },
})

cmp.setup.filetype({ 'dap-repl', 'dapui_watches', 'dapui_hover' }, {
  sources = {
    { name = 'dap' },
  },
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'nvim_lsp_document_symbol' },
    { name = 'buffer' },
    { name = 'cmdline_history' },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources {
    { name = 'path' },
    { name = 'cmdline' },
    { name = 'cmdline_history' },
  },
})
