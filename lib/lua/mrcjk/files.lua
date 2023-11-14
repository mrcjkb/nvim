local files = {}

local disabled_files = {
  'Enums.hs',
  'all-packages.nix',
  'hackage-packages.nix',
  'generated.nix',
}

---@param bufnr number
---@return boolean
function files.disable_treesitter_features(bufnr)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  local short_name = vim.fn.fnamemodify(fname, ':t')
  return vim.tbl_contains(disabled_files, short_name)
end

return files
