---@diagnostic disable: missing-fields
local cmp = require('cmp')
local lspkind = require('lspkind')
local luasnip = require('luasnip')

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

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
      else
        fallback()
      end
    end, { 'i', 'c', 's' }),
    ['<C-p>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
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
    ['<C-y>'] = cmp.mapping(function(_)
      local entry = cmp.get_selected_entry()
      if not entry then
        cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
      end
      cmp.confirm {
        select = true,
      }
    end, { 'i', 'c', 's' }),
    -- ['<C-o>'] = complete_with_source_mapping('omni', { 'i', 'c' }),
    ['<C-s>'] = complete_with_source_mapping('luasnip', { 'i', 's' }),
  },
  sources = cmp.config.sources {
    -- The insertion order appears to influence the priority of the sources
    -- {
    --   name = 'omni',
    --   disable_omnifuncs = { 'v:lua.vim.lsp.omnifunc' },
    -- },
    { name = 'nvim_lsp', keyword_length = 3 },
    { name = 'nvim_lsp_signature_help', keyword_length = 3 },
    { name = 'luasnip_choice' }, -- luasnip choice nodes
    { name = 'buffer' },
    { name = 'rg', keyword_length = 3 },
    {
      name = 'tmux',
      keyword_length = 3,
      all_panes = true,
    },
    { name = 'path' },
    -- { name = 'buffer-lines', keyword_length = 3 },
  },
  enabled = function()
    return vim.bo[0].buftype ~= 'prompt'
  end,
  experimental = {
    native_menu = false,
    ghost_text = true,
  },
}

cmp.setup.filetype('lua', {
  sources = cmp.config.sources {
    { name = 'nvim_lua' },
    { name = 'nvim_lsp', keyword_length = 3 },
    { name = 'nvim_lsp_signature_help', keyword_length = 3 },
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
})

cmp.setup.filetype('norg', {
  sources = cmp.config.sources {
    { name = 'neorg' },
    { name = 'rg' },
    { name = 'buffer' },
    { name = 'path' },
  },
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'nvim_lsp_document_symbol', keyword_length = 3 },
    { name = 'buffer' },
    { name = 'cmdline_history' },
  },
  view = {
    entries = { name = 'wildmenu', separator = '|' },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline {
    ['<tab>'] = {
      i = ...,
      c = cmp.config.disable,
    },
  },
  sources = cmp.config.sources {
    { name = 'cmdline' },
    { name = 'cmdline_history' },
    { name = 'path' },
  },
})

require('cmp_luasnip_choice').setup()

vim.keymap.set({ 'i', 'c', 's' }, '<C-n>', cmp.complete, { noremap = false, desc = 'cmp: complete' })
vim.keymap.set({ 'i', 'c', 's' }, '<C-f>', function()
  complete_with_source('path')
end, { noremap = false, desc = 'cmp: path' })
vim.keymap.set({ 'i', 'c', 's' }, '<C-g>', function()
  complete_with_source('rg')
end, { noremap = false, desc = 'cmp: rg' })
vim.keymap.set({ 'i', 'c', 's' }, '<C-o>', function()
  complete_with_source('nvim_lsp')
end, { noremap = false, desc = 'cmp: lsp' })
vim.keymap.set({ 'i', 'c', 's' }, '<C-t>', function()
  complete_with_source {
    name = 'tmux',
    keyword_length = 3,
    all_panes = true,
  }
end, { noremap = false, desc = 'cmp: tmux' })
vim.keymap.set({ 'c' }, '<C-h>', function()
  complete_with_source('cmdline_history')
end, { noremap = false, desc = 'cmp: cmdline history' })
vim.keymap.set({ 'c' }, '<C-c>', function()
  complete_with_source('cmdline')
end, { noremap = false, desc = 'cmp: cmdline' })
vim.keymap.set({ 'c' }, '<tab>', function()
  complete_with_source('cmdline')
end, { noremap = false, desc = 'cmp: cmdline' })
