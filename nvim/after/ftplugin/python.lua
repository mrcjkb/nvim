local files = require('mrcjk.files')
files.treesitter_start()

if vim.bo[0].buftype == 'nofile' then
  return
end

local lsp = require('mrcjk.lsp')

local pylsp_cmd = 'pylsp'
local ty_cmd = 'ty'
local cmd
local settings

if vim.fn.executable(ty_cmd) == 1 then
  cmd = { ty_cmd, 'server' }
  settings = {}
elseif vim.fn.executable(pylsp_cmd) == 1 then
  cmd = { pylsp_cmd }
  settings = {
    pylsp = {
      plugins = {
        flake8 = { enabled = true },
        pycodestyle = { enabled = false },
        pyflakes = { enabled = false },
        pylint = { enabled = false },
        mccabe = { enabled = false },
      },
    },
  }
else
  return
end

local config = {
  cmd = cmd,
  root_dir = vim.fs.dirname(vim.fs.find({ '.git', 'setup.py', 'setup.cfg', 'pyproject.toml' }, { upward = true })[1]),
  capabilities = lsp.capabilities,
  filetypes = { 'python' },
  settings = settings,
}

local bufnr = vim.api.nvim_get_current_buf()

vim.lsp.start(config, {
  bufnr = bufnr,
  reuse_client = function(client, conf)
    return client.name == conf.name and client.config.root_dir == conf.root_dir
  end,
})
