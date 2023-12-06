require('neorg').setup {
  load = {
    ['core.defaults'] = {}, -- Loads default behaviour
    ['core.concealer'] = {}, -- Adds pretty icons to your documents
    ['core.completion'] = {
      config = {
        engine = 'nvim-cmp',
      },
    },
    ['core.dirman'] = { -- Manages Neorg workspaces
      config = {
        workspaces = {
          tiko = '~/notes/tiko',
          home = '~/notes/home',
        },
      },
    },
  },
}
