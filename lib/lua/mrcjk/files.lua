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

---@param lang? string
---@param bufnr? number
function files.treesitter_start(lang, bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  lang = lang or vim.bo[bufnr].ft
  if files.disable_treesitter_features(bufnr) then
    return
  end
  vim.treesitter.start(bufnr, lang)
end

return files
