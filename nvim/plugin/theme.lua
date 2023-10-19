require('catppuccin').setup {
  color_overrides = {
    mocha = {
      base = '#151515',
      mantle = '#151515',
      crust = '#151515',
    },
  },
  integrations = {
    telescope = {
      enabled = true,
      style = 'nvchad',
    },
    dropbar = {
      enabled = true,
      color_mode = true,
    },
  },
}
vim.cmd.colorscheme('catppuccin')
