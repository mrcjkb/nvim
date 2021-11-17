local telescope = require'telescope'
local actions = require'telescope.actions'
local api = vim.api

local opts = { noremap=true, silent=true }
api.nvim_set_keymap('n', '<C-p>', '<Cmd>Telescope find_files<CR>', opts)
api.nvim_set_keymap('n', '<C-g>', '<Cmd>Telescope live_grep<CR>', opts)
api.nvim_set_keymap('n', '<leader>*', '<Cmd>Telescope grep_string<CR>', opts) -- Search for string under the cursor
api.nvim_set_keymap('n', '<leader>tg', '<Cmd>Telescope git_files<CR>', opts)
api.nvim_set_keymap('n', '<leader>tc', '<Cmd>Telescope quickfix<CR>', opts)
api.nvim_set_keymap('n', '<leader>tl', '<Cmd>Telescope loclist<CR>', opts)
api.nvim_set_keymap('n', '<leader>tr', '<Cmd>Telescope registers<CR>', opts)
api.nvim_set_keymap('n', '<leader>tb', '<Cmd>Telescope buffers<CR>', opts)
api.nvim_set_keymap('n', '<leader>tf', '<Cmd>Telescope current_buffer_fuzzy_find<CR>', opts)
api.nvim_set_keymap('n', '<leader>td', '<Cmd>Telescope lsp_document_symbols<CR>', opts)
api.nvim_set_keymap('n', '<leader>to', '<Cmd>Telescope lsp_workspace_symbols<CR>', opts)
api.nvim_set_keymap('n', '<leader>ta', '<Cmd>Telescope lsp_code_actions<CR>', opts)
api.nvim_set_keymap('n', '<leader>ts', '<Cmd>Telescope ultisnips ultisnips<CR>', opts)
api.nvim_set_keymap('n', '<leader>th', '<Cmd>Telescope hoogle<CR>', opts)

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
      },
    }
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    }
  }
}

telescope.load_extension('ultisnips')
telescope.load_extension('hoogle')
telescope.load_extension('fzy_native')

