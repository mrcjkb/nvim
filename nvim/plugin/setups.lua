local function setup(mod)
  require(mod).setup()
end

-- setup('wildfire')
setup('Comment')

if not vim.g.nvim_surround_setup then
  setup('nvim-surround')
  vim.g.nvim_surround_setup = true
end
