local telescope = require'telescope'
local actions = require'telescope.actions'

local M = {}
-- Fall back to find_files if not in a git repo
M.project_files = function()
  local opts = {} -- define here if you want to define something
  local ok = pcall(require"telescope.builtin".git_files, opts)
  if not ok then require"telescope.builtin".find_files(opts) end
end


vim.keymap.set('n', '<C-p>', telescope.builtin.find_files, { })
vim.keymap.set('n', '<C-g>', telescope.builtin.live_grep, { })
-- TODO: Add live_grpe call with vimgrep_arguments that filters --type for the current file type
-- @see https://github.com/nvim-telescope/telescope.nvim/blob/ad32a4c4535af9feae1f16129de22cfc57921ef8/lua/telescope/builtin/__files.lua
vim.keymap.set('n', '<leader>*', telescope.builtin.grep_string, { })
vim.keymap.set('n', '<leader>tg', require'telescope-config'.project_files, { })
vim.keymap.set('n', '<leader>tc', telescope.builtin.quickfix, { })
vim.keymap.set('n', '<leader>tq', telescope.builtin.command_history, { })
vim.keymap.set('n', '<leader>tl', telescope.builtin.loclist, { })
vim.keymap.set('n', '<leader>tr', telescope.builtin.registers, { })
vim.keymap.set('n', '<leader>tp', '<Cmd>Telescope repo list<CR>', { })
vim.keymap.set('n', '<leader>tb', telescope.builtin.buffers, { })
vim.keymap.set('n', '<leader>tf', telescope.builtin.current_buffer_fuzzy_find, { })
vim.keymap.set('n', '<leader>td', telescope.builtin.lsp_document_symbols, { })
vim.keymap.set('n', '<leader>ta', telescope.builtin.lsp_code_actions, { })
vim.keymap.set('n', '<leader>ts', '<Cmd>Telescope ultisnips ultisnips<CR>', { })
vim.keymap.set('n', '<leader>th', '<Cmd>Telescope hoogle<CR>', { })
vim.keymap.set('n', '<leader>to', telescope.builtin.lsp_dynamic_workspace_symbols, { })
-- api.nvim_set_keymap('n', '<leader>to', '<Cmd>Telescope lsp_workspace_symbols<CR>', opts)

-- Don't preview binaries
local previewers = require("telescope.previewers")
local Job = require("plenary.job")
local new_maker = function(filepath, bufnr, opts)
  filepath = vim.fn.expand(filepath)
  Job:new({
    command = "file",
    args = { "--mime-type", "-b", filepath },
    on_exit = function(j)
      local mime_type = vim.split(j:result()[1], "/")[1]
      if mime_type == "text" then
        previewers.buffer_previewer_maker(filepath, bufnr, opts)
      else
        -- maybe we want to write something to the buffer here
        vim.schedule(function()
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
        end)
      end
    end
  }):sync()
end


telescope.setup {
  defaults = {
    path_display = { 
      "shorten",
    },
    -- layout_config = {
      -- vertical = {
        --   width = 100,
      --   }
    -- },
    mappings = {
      i = {
        ['<C-q>'] = actions.send_to_qflist,
        ['<C-l>'] = actions.send_to_loclist,
      },
    },
    preview = {
      treesitter = true
    },
    buffer_previewer_maker = new_maker,
    history = {
      path = vim.fn.stdpath('data') .. '/telescope_history.sqlite3',
      limit = 1000,
    },
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    }
  },
}

telescope.load_extension('hoogle')
telescope.load_extension('repo')
telescope.load_extension('fzy_native')
telescope.load_extension('smart_history')
telescope.load_extension('cheat') 

return M
