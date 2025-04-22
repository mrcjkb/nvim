require('other-nvim').setup {
  transformers = {
    lowercase = function(inputString)
      return inputString:lower()
    end,
  },
  mappings = {
    -- Haskell
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
        {
          target = '%1/src/%2/*%3.Internal.hs',
          context = 'internal',
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
          target = '%1/src/%2/%3.hs',
          context = 'public',
        },
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
      contect = 'impl',
    },
    {
      pattern = '(.+)/test/(.*)/(.*)Spec.hs$',
      target = '%1/src/%2/%3/Internal.hs',
      contect = 'internal-impl',
    },
    {
      pattern = '(.+)/test/(.*)/(.*)Test.hs$',
      target = '%1/src/%2/%3.hs',
      contect = 'impl',
    },
    {
      pattern = '(.+)/test/(.*)/(.*)Test.hs$',
      target = '%1/src/%2/%3/Internal.hs',
      contect = 'internal-impl',
    },
    {
      pattern = '(.+)/test/(.*)/Tiko(.*)Test.hs$',
      target = '%1/src/%2/%3.hs',
      contect = 'impl',
    },
    {
      pattern = '(.+)/test/(.*)/Tiko(.*)Test.hs$',
      target = '%1/src/%2/%3/Internal.hs',
      contect = 'internal-impl',
    },
    {
      pattern = '(.+)/spec/(.*)/(.*)Spec.hs$',
      target = '%1/src/%2/%3.hs',
      contect = 'impl',
    },
    {
      pattern = '(.+)/spec/(.*)/(.*)Spec.hs$',
      target = '%1/src/%2/%3/Internal.hs',
      contect = 'internal-impl',
    },
    {
      pattern = '(.+)/spec/(.*)/(.*)Test.hs$',
      target = '%1/src/%2/%3.hs',
      contect = 'impl',
    },
    {
      pattern = '(.+)/spec/(.*)/(.*)Test.hs$',
      target = '%1/src/%2/%3/Internal.hs',
      contect = 'internal-impl',
    },
    {
      pattern = '(.+)/spec/(.*)/Tiko(.*)Test.hs$',
      target = '%1/src/%2/%3.hs',
      contect = 'impl',
    },
    {
      pattern = '(.+)/spec/(.*)/Tiko(.*)Test.hs$',
      target = '%1/src/%2/%3/Internal.hs',
      contect = 'internal-impl',
    },

    -- Java
    {
      pattern = '(.+)/src/main/(.*)/(.*).java$',
      target = {
        {
          target = '%1/src/test/%2/%3Test.java',
          context = 'test',
        },
      },
    },
    {
      pattern = '(.+)/src/test/(.*)/(.*)Test.java$',
      target = {
        {
          target = '%1/src/main/%2/%3.java',
        },
      },
    },
  },
}

vim.keymap.set('n', '<leader>oo', function()
  vim.cmd.Other()
end, { noremap = true, silent = true, desc = '[o]ther' })
