local lsp = require('mrcjk.lsp')

local pylsp_cmd = 'pylsp'

if vim.fn.executable(pylsp_cmd) ~= 1 then
  return
end

local config = {
  cmd = { pylsp_cmd },
  root_dir = vim.fs.dirname(vim.fs.find({ '.git', 'setup.py', 'setup.cfg', 'pyproject.toml' }, { upward = true })[1]),
  on_attach = lsp.on_dap_attach,
  capabilities = lsp.capabilities,
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
  },
}

local bufnr = vim.api.nvim_get_current_buf()

vim.lsp.start(config, {
  bufnr = bufnr,
  reuse_client = function(client, conf)
    return client.name == conf.name and client.config.root_dir == conf.root_dir
  end,
})
