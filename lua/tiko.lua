local api = vim.api
local fn = vim.fn

-- Style current buffer
local augroup = api.nvim_create_augroup('tiko', {})

local home = os.getenv('HOME')

local is_buf_modified = function(bufnr)
  for _, buf in pairs(fn.getbufinfo(bufnr)) do
    if buf["bufmodified"] == 1 then
      return true
    end
    if buf["bufmodified"] ~= 1 then
      return false
    end
  end
  return false
end

-- FIXME
local tiko_style_cur_buf_if_not_modified = function()
    local buf = api.nvim_get_current_buf()
    local filepath = api.nvim_buf_get_name(0) 
    local command = 'stylish-haskell ' .. filepath .. ' -c cli/lint/stylish-haskell.yaml'
    local handle = io.popen(command)
    local styled = handle:read("*a")
    handle:close()
    vim.inspect(styled)
    if not is_buf_modified(buf) then
      return
    end
    api.nvim_buf_set_lines(buf, 0, -1, true, styled)
end

api.nvim_create_autocmd({'BufNewFile', 'BufRead',}, {
  group = augroup,
  pattern = home .. '/git/tiko-backend/backend/*',
  callback = function()
    api.nvim_create_autocmd('FileType', {
      group = augroup,
      pattern = 'haskell',
      callback = function()
        api.nvim_create_user_command('BufTikoStyle', tiko_style_cur_buf_if_not_modified, {})
        api.nvim_create_autocmd('BufWritePost', {
          group = augroup,
          pattern = '<buffer>',
          callback = tiko_style_cur_buf_if_not_modified
        })
      end,
    })
  end
})

-- Style current buffer after writing Haskell files
-- au BufNewFile,BufRead $HOME/git/tiko-backend/backend/*
--       \ au FileType haskell 
--       \ au BufWritePost <buffer> :BufTikoStyle
--
-- nnoremap <leader>s :write \| BufTikoStyle<CR>
--
-- " let g:test#haskell#stacktest#file_pattern = '\v^(.*spec.*|.*test.*)\c\.hs$'
