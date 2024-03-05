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

local function desc(description)
  return { noremap = true, silent = true, desc = description }
end

vim.keymap.set('n', '<leader>oo', function()
  vim.cmd.Other()
end, desc('[oo]ther'))

vim.keymap.set('n', '<leader>os', function()
  vim.cmd.Other('spec')
end, desc('[o]ther: [s]pec'))

vim.keymap.set('n', '<leader>ot', function()
  vim.cmd.Other('test')
end, desc('[o]ther: [t]est'))

vim.keymap.set('n', '<leader>oi', function()
  vim.cmd.Other('impl')
end, desc('[o]ther: [i]mpl'))

vim.keymap.set('n', '<leader>oI', function()
  vim.cmd.Other('internal-impl')
end, desc('[o]ther: [I]nternal-impl'))
