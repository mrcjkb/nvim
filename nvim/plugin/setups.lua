local function setup(mod)
  require(mod).setup()
end

if not vim.g.nvim_surround_setup then
  setup('nvim-surround')
  vim.g.nvim_surround_setup = true
end
