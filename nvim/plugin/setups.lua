local function try_setup(plugin)
  local ok, mod = pcall(require, plugin)
  if not ok then
    return
  end
  mod.setup()
end

try_setup('wildfire')
try_setup('colorizer')
try_setup('nvim-lastplace')
try_setup('Comment')
try_setup('neoconf')
try_setup('todo-comments')
try_setup('tmux')
try_setup('nvim-highlight-colors')

if not vim.g.nvim_surround_setup then
  try_setup('nvim-surround')
  vim.g.nvim_surround_setup = true
end
