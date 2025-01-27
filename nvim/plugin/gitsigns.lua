if vim.g.gitsigns_nvim_setup_done then
  return
end
vim.api.nvim_create_autocmd('FileType', {
  once = true,
  pattern = '*',
  group = vim.api.nvim_create_augroup('gitsigns-nvim-setup', {}),
  callback = function()
    if vim.g.gitsigns_nvim_setup_done then
      return
    end
    vim.g.gitsigns_nvim_setup_done = true
    vim.schedule(function()
      require('gitsigns').setup {
        current_line_blame = true,
        current_line_blame_opts = {
          ignore_whitespace = true,
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']g', function()
            if vim.wo.diff then
              return ']g'
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return '<Ignore>'
          end, { expr = true, desc = '[g]it: next hunk' })

          map('n', '[g', function()
            if vim.wo.diff then
              return '[g'
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return '<Ignore>'
          end, { expr = true, desc = '[g]it: previous hunk' })

          -- Actions
          map({ 'n', 'v' }, '<leader>gh', function()
            vim.cmd.Gitsigns('stage_hunk')
          end, { desc = '[g]it: stage [h]unk' })
          map({ 'n', 'v' }, '<leader>[g]r', function()
            vim.cmd.Gitsigns('reset_hunk')
          end, { desc = '[g]it: [r]eset hunk' })
          map('n', '<leader>g[S]', gs.stage_buffer, { desc = '[g]it: [S]tage buffer' })
          map('n', '<leader>gu', gs.undo_stage_hunk, { desc = '[g]it: [u]ndo stage hunk' })
          map('n', '<leader>gR', gs.reset_buffer, { desc = '[g]it: [R]eset buffer' })
          map('n', '<leader>gp', gs.preview_hunk, { desc = '[g]it: [p]review hunk' })
          map('n', '<leader>gL', function()
            gs.blame_line { full = true }
          end, { desc = '[g]it: blame [L]ine (full)' })
          map('n', '<leader>glb', gs.toggle_current_line_blame, { desc = '[g]it: toggle [l]ine [b]lame' })
          map('n', '<leader>gDt', gs.diffthis, { desc = '[g]it: [D]iff [t]his' })
          map('n', '<leader>gDD', function()
            gs.diffthis('~')
          end, { desc = '[g]it: [DD]iff ~' })
          map('n', '<leader>gtd', gs.toggle_deleted, { desc = '[g]it: [t]oggle [d]eleted' })
          -- Text object
          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'git: [i]nner [h]unk' })
        end,
      }
    end)
  end,
})
