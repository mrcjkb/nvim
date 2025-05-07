vim.api.nvim_create_autocmd({ 'BufFilePost', 'BufAdd', 'BufNew' }, {
  callback = function(ev)
    local buf_name = vim.api.nvim_buf_get_name(ev.buf)
    if buf_name:match('\r$') then
      vim.notify(
        string.format(
          [[Ghost file created:
%s

Stacktrace:
%s
]],
          vim.inspect(ev),
          debug.traceback()
        ),
        vim.log.levels.WARN
      )
    end
  end,
})
