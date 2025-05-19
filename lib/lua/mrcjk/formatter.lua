local has_fourmolu = vim.fn.executable('fourmolu') == 1
local has_ormolu = vim.fn.executable('ormolu') == 1
local has_stylua = vim.fn.executable('stylua') == 1
require('formatter').setup {
  filetype = {
    haskell = has_fourmolu and {
      require('formatter.filetypes.haskell').fourmolu,
    } or has_ormolu and {
      require('formatter.filetypes.haskell').ormolu,
    } or {},
    lua = has_stylua
        and {
          -- "formatter.filetypes.lua" defines default configurations for the
          -- "lua" filetype
          require('formatter.filetypes.lua').stylua,
        }
      or {},
  },
}
local pattern = {}
if has_fourmolu or has_ormolu then
  table.insert(pattern, '*.hs')
end
if has_stylua then
  table.insert(pattern, '*.lua')
end
vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('post-write-format', {}),
  pattern = pattern,
  command = 'Format',
})

---@param bufnr integer
local function should_use_format_cmd(bufnr)
  local ft = vim.bo[bufnr].filetype
  return ft == 'lua' and has_stylua or ft == 'hs' and (has_fourmolu or has_ormolu)
end

vim.keymap.set('n', '<space>f', function()
  local bufnr = vim.api.nvim_get_current_buf()
  if should_use_format_cmd(bufnr) then
    vim.cmd.Format()
  elseif #vim.lsp.get_clients { bufnr = bufnr } >= 0 then
    vim.lsp.buf.format { async = true }
  end
end, { noremap = true, silent = true, desc = '[f]format [f]ile' })

return true
