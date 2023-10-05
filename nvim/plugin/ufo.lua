vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = '[fold] open all' })
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = '[fold] close all' })
vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds, { desc = '[fold] open' })
vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith, { desc = '[fold] close' }) -- closeAllFolds == closeFoldsWith(0)
vim.keymap.set('n', 'K', function()
  local winid = require('ufo').peekFoldedLinesUnderCursor()
  if not winid then
    vim.lsp.buf.hover()
  end
end, { desc = 'peek folds or hover' })

local function handler(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (' 󰁂 %d '):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, 'MoreMsg' })
  return newVirtText
end

---@diagnostic disable-next-line: missing-fields
require('ufo').setup {
  open_fold_hl_timeout = 150,
  close_fold_kinds = { 'imports', 'comment' },
  preview = {
    win_config = {
      border = { '', '─', '', '', '', '─', '', '' },
      winhighlight = 'Normal:Folded',
      winblend = 0,
    },
    mappings = {
      scrollU = '<C-u>',
      scrollD = '<C-d>',
    },
  },
  fold_virt_text_handler = handler,
  provider_selector = function(_, filetype, buftype)
    if filetype == 'nix' or filetype == 'yaml' then
      return { 'treesitter', 'indent' }
    end
    local function handleFallbackException(bufnr, err, providerName)
      if type(err) == 'string' and err:match('UfoFallbackException') then
        return require('ufo').getFolds(bufnr, providerName)
      else
        return require('ufo').getFolds(bufnr, 'indent')
      end
    end

    return (filetype == '' or buftype == 'nofile') and 'indent' -- only use indent until a file is opened
      or function(bufnr)
        return require('ufo')
          .getFolds(bufnr, 'lsp')
          :catch(function(err)
            return handleFallbackException(bufnr, err, 'treesitter')
          end)
          :catch(function(err)
            return handleFallbackException(bufnr, err, 'indent')
          end)
      end
  end,
}
