local configs = require('nvim-treesitter.configs')
configs.setup {
  ensure_installed = 'all',
  ignore_install = { 'gitignore', 'sql' }, -- broken
  auto_install = true, -- Automatically install missing parsers when entering buffer
  highlight = {
    enable = true,
    disable = function(_, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },
  rainbow = {
    enable = true,
    extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
    max_file_lines = 500, -- Do not enable for files with more than 1000 lines, int
  },
  textobjects = {
    select = {
      enable = true,
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ['aC'] = '@call.outer',
        ['iC'] = '@call.inner',
        ['a#'] = '@comment.outer',
        ['i#'] = '@comment.outer',
        ['ai'] = '@conditional.outer',
        ['ii'] = '@conditional.outer',
        ['al'] = '@loop.outer',
        ['il'] = '@loop.inner',
        ['aP'] = '@parameter.outer',
        ['iP'] = '@parameter.inner',
      },
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']P'] = '@parameter.outer',
      },
      goto_next_end = {
        [']m'] = '@function.outer',
        [']P'] = '@parameter.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[P'] = '@parameter.outer',
      },
      goto_previous_end = {
        ['[m'] = '@function.outer',
        ['[P'] = '@parameter.outer',
      },
    },
    lsp_interop = {
      enable = true,
      peek_definition_code = {
        ['df'] = '@function.outer',
        ['dF'] = '@class.outer',
      },
    },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
  },
  refactor = {
    highlight_current_scope = { enable = true },
    highlight_definitions = {
      enable = false, -- replaced with vim-illuminate plugin
      -- Set to false if you have an `updatetime` of ~100.
      clear_on_cursor_move = true,
    },
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = 'grr',
      },
    },
    navigation = {
      enable = true,
      keymaps = {
        goto_definition = 'gnd',
        list_definitions = 'gnD',
        list_definitions_toc = 'gO',
        goto_next_usage = '<a-*>',
        goto_previous_usage = '<a-#>',
      },
    },
  },
  playground = { -- Toggle with :TSPlaygroundToggle
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { 'BufWrite', 'CursorHold' },
  },
}

-- Tree-sitter based folding
-- disabled. Folding is managed by nvim-ufo
-- vim.opt.foldmethod = 'expr'
-- vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
