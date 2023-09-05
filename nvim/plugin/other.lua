require('other-nvim').setup {
  transformers = {
    lowercase = function(inputString)
      return inputString:lower()
    end,
  },
  mappings = {
    {
      pattern = '(.+)/src/(.*)/(.*).hs$',
      target = {
        {
          target = '%1/test/%2/%3Spec.hs',
          context = 'spec',
        },
        {
          target = '%1/test/%2/*%3Test.hs',
          context = 'test',
        },
        -- FIXME:
        -- {
        --   target = '/nix/configs/**/.*%3*.nix',
        --   context = 'nix',
        --   transformer = 'lowercase',
        -- },
      },
    },
    {
      pattern = '(.+)/test/(.*)/(.*)Spec.hs$',
      target = '%1/src/%2/%3.hs',
    },
    {
      pattern = '(.+)/test/(.*)/(.*)Test.hs$',
      target = '%1/src/%2/%3.hs',
    },
    {
      pattern = '(.+)/test/(.*)/Tiko(.*)Test.hs$',
      target = '%1/src/%2/%3.hs',
    },
  },
}

local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<leader>oo', function()
  vim.cmd.Other()
end, opts)

vim.keymap.set('n', '<leader>os', function()
  vim.cmd.Other('spec')
end, opts)

vim.keymap.set('n', '<leader>ot', function()
  vim.cmd.Other('test')
end, opts)
