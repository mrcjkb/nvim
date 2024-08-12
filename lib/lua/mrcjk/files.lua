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
  if vim.tbl_contains(disabled_files, short_name) then
    return true
  end
  local max_filesize = 100 * 1024 -- 100 KiB
  local ok, stats = pcall(vim.uv.fs_stat, fname)
  if ok and stats and stats.size > max_filesize then
    return true
  end
  return false
end

return files
