local cmp = require('cmp')
local lspkind = require('lspkind')
local luasnip = require('luasnip')

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

local function has_words_before()
  local unpack_ = unpack or table.unpack
  local line, col = unpack_(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

---@param source string|table
local function complete_with_source(source)
  if type(source) == 'string' then
    cmp.complete { config = { sources = { { name = source } } } }
  elseif type(source) == 'table' then
    cmp.complete { config = { sources = { source } } }
  end
end

local function complete_with_source_mapping(name, modes)
  return cmp.mapping.complete { config = { sources = { { name = name } } }, modes }
end

cmp.setup {
  completion = {
    completeopt = 'menu,menuone,noinsert',
    autocomplete = false,
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
        nvim_lsp_signature_help = '[LSP]',
        nvim_lsp_document_symbol = '[LSP]',
        nvim_lua = '[API]',
        path = '[PATH]',
        luasnip = '[SNIP]',
        luasnip_choice = '[CHOICE]',
        rg = '[RG]',
        cmdline = '[CMD]',
        cmdline_history = '[HISTORY]',
        cmp_git = '[GIT]',
        tmux = '[TMUX]',
      },
    },
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping(function(_)
      if cmp.visible() then
        cmp.scroll_docs(-4)
      else
        complete_with_source('buffer')
      end
    end, { 'i', 'c', 's' }),
    ['<C-f>'] = cmp.mapping(function(_)
      if cmp.visible() then
        cmp.scroll_docs(4)
      else
        complete_with_source('path')
      end
    end, { 'i', 'c', 's' }),
    ['<C-n>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      -- expand_or_jumpable(): Jump outside the snippet region
      -- expand_or_locally_jumpable(): Only jump inside the snippet region
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 'c', 's' }),
    ['<C-p>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 'c', 's' }),
    -- toggle completion
    ['<C-e>'] = cmp.mapping(function(_)
      if cmp.visible() then
        cmp.close()
      else
        cmp.complete()
      end
    end, { 'i', 'c', 's' }),
    ['<C-y>'] = cmp.mapping.confirm {
      select = true,
    },
    ['<C-o>'] = complete_with_source_mapping('omni', { 'i', 'c' }),
    ['<C-r>'] = complete_with_source_mapping('rg', { 'i', 's' }),
    ['<C-s>'] = complete_with_source_mapping('luasnip', { 'i', 's' }),
  },
  sources = cmp.config.sources {
    -- The insertion order appears to influence the priority of the sources
    {
      name = 'omni',
      disable_omnifuncs = { 'v:lua.vim.lsp.omnifunc' },
    },
    { name = 'nvim_lua' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    -- { name = 'luasnip' }, -- snippets -> Triggered with <C-s>
    { name = 'luasnip_choice' }, -- luasnip choice nodes
    { name = 'rg', keyword_length = 3 },
    { name = 'buffer', keyword_length = 3 },
    {
      name = 'tmux',
      keyword_length = 3,
      all_panes = true,
    },
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
  view = {
    entries = { name = 'wildmenu', separator = '|' },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources {
    { name = 'cmdline' },
    { name = 'cmdline_history' },
    { name = 'path' },
  },
})

require('cmp_luasnip_choice').setup()

local opts = { noremap = false }
vim.keymap.set({ 'i', 'c', 's' }, '<C-n>', cmp.complete, opts)
vim.keymap.set({ 'i', 'c', 's' }, '<C-p>', cmp.complete, opts)
vim.keymap.set({ 'i', 'c', 's' }, '<C-f>', function()
  complete_with_source('path')
end, opts)
vim.keymap.set({ 'i', 'c', 's' }, '<C-g>', function()
  complete_with_source('rg')
end, opts)
vim.keymap.set({ 'i', 'c', 's' }, '<C-t>', function()
  complete_with_source {
    name = 'tmux',
    keyword_length = 3,
    all_panes = true,
  }
end, opts)
