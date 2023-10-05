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
          target = '%1/spec/%2/%3Spec.hs',
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
      pattern = '(.+)/src/(.*)/(.*)/Internal.hs$',
      target = {
        {
          target = '%1/test/%2/%3Spec.hs',
          context = 'spec',
        },
        {
          target = '%1/spec/%2/%3Spec.hs',
          context = 'spec',
        },
        {
          target = '%1/test/%2/*%3Test.hs',
          context = 'test',
        },
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

local function desc(description)
  return { noremap = true, silent = true, desc = description }
end

vim.keymap.set('n', '<leader>oo', function()
  vim.cmd.Other()
end, desc('[other]'))

vim.keymap.set('n', '<leader>os', function()
  vim.cmd.Other('spec')
end, desc('[other] spec'))

vim.keymap.set('n', '<leader>ot', function()
  vim.cmd.Other('test')
end, desc('[other] test'))
