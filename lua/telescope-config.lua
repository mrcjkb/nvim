local telescope = require'telescope'
local actions = require'telescope.actions'
local api = vim.api

local M = {}

-- Fall back to find_files if not in a git repo
M.project_files = function()
  local opts = {} -- define here if you want to define something
  local ok = pcall(require"telescope.builtin".git_files, opts)
  if not ok then require"telescope.builtin".find_files(opts) end
end


local opts = { noremap=true, silent=true }
api.nvim_set_keymap('n', '<C-p>', '<Cmd>Telescope find_files<CR>', opts)
api.nvim_set_keymap('n', '<C-g>', '<Cmd>Telescope live_grep<CR>', opts)
api.nvim_set_keymap('n', '<leader>*', '<Cmd>Telescope grep_string<CR>', opts) -- Search for string under the cursor
api.nvim_set_keymap('n', '<leader>tg', "<CMD>lua require'telescope-config'.project_files()<CR>", opts)
api.nvim_set_keymap('n', '<leader>tc', '<Cmd>Telescope quickfix<CR>', opts)
api.nvim_set_keymap('n', '<leader>tq', '<Cmd>Telescope command_history<CR>', opts)
api.nvim_set_keymap('n', '<leader>tl', '<Cmd>Telescope loclist<CR>', opts)
api.nvim_set_keymap('n', '<leader>tr', '<Cmd>Telescope registers<CR>', opts)
api.nvim_set_keymap('n', '<leader>tp', '<Cmd>Telescope repo list<CR>', opts)
api.nvim_set_keymap('n', '<leader>tb', '<Cmd>Telescope buffers<CR>', opts)
api.nvim_set_keymap('n', '<leader>tf', '<Cmd>Telescope current_buffer_fuzzy_find<CR>', opts)
api.nvim_set_keymap('n', '<leader>td', '<Cmd>Telescope lsp_document_symbols<CR>', opts)
api.nvim_set_keymap('n', '<leader>ta', '<Cmd>Telescope lsp_code_actions<CR>', opts)
api.nvim_set_keymap('n', '<leader>ts', '<Cmd>Telescope ultisnips ultisnips<CR>', opts)
api.nvim_set_keymap('n', '<leader>th', '<Cmd>Telescope hoogle<CR>', opts)
api.nvim_set_keymap('n', '<leader>to', '<Cmd>lua require\'telescope.builtin\'.lsp_dynamic_workspace_symbols{}<CR>', opts)
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
      path = vim.fn.stdpath('data') .. '/databases/telescope_history.sqlite3',
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
-- telescope.load_extension('cheat') -- FIXME

return M
