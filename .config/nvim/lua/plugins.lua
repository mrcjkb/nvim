-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)

  use 'wbthomason/packer.nvim'

  -- use 'MrcJkb/nvim-java-tsls'
  -- use 'MrcJkb/autofix.nvim'

  -- lazy loaded
  -- proviedes lua scratch pad
  use { 'bfredl/nvim-luadev', opt = true, cmd = { 'Luadev' }}

  -- use { 
  --   'weirongxu/plantuml-previewer.vim',
  --   requires = {
  --     'tyru/open-browser.vim',
  --     'aklt/plantuml-syntax',
  --   }
  -- }

  -- use {
  --   'iamcco/markdown-preview.nvim',
  --   run = function() vim.fn['mkdp#util#install']() end,
  --   -- ft = {'markdown'}
  -- }

  use {"ellisonleao/glow.nvim"}

  -- CamelCase, snake_case, etc word motions
  use { 
    'chaoren/vim-wordmotion'
  }

  -- -- Syntax highlighting/indentation
  -- use {
  --   'sheerun/vim-polyglot',
  --   setup = function()
  --     vim.g['polyglot_disabled'] = {'java'}
  --   end
  -- }

  -- Highlight colours (e.g. #800080)
  use 'norcalli/nvim-colorizer.lua'

  -- Remaps s [cl] and S [cc] to vertical sneak search
  -- Note: I have it mapped to <M-f> and <M-F>, respectively
  use {
  'justinmk/vim-sneak',
  setup = function()
    vim.g['sneak#label'] = 1
    vim.g['sneak#prompt'] = '🔍'
    vim.cmd [[
      map <M-f> <Plug>Sneak_s
    ]]
  end
}

  -- Highlight unique characters in line search
  use 'unblevable/quick-scope'

  -- User-defined textobjects
  use 'kana/vim-textobj-user'

  -- .editorconfig support
  use {
  'editorconfig/editorconfig-vim',
  setup = function()
    vim.g['EditorConfig_exclude_patterns'] = {'fugitive://.*'}
  end
}

  -- Git wrapper
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb' -- GitHub fugitive plugin for :GBrowse
  use 'tommcdo/vim-fubitive' -- Bitbucket fugitive plugin for :GBrowse
  use {
    'shumphrey/fugitive-gitlab.vim', -- GitLab fugitive support for :GBrowse
    setup = function()
      vim.g['g:fugitive_gitlab_domains'] = {'ssh://gitlab.internal.tiko.ch', 'https://gitlab.internal.tiko.ch'}
    end
  }
  
  -- Add repeat . suppor to custom commands
  use 'tpope/vim-repeat'
  -- Vim sugar for UNIX shell commands (:Move, :Mkdir, :SudoWrite, etc.)
  use 'tpope/vim-eunuch'
  use 'tpope/vim-projectionist' -- alternate file configs
  -- Navigation with [ and ] keybindings
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-dispatch' 
  use 'tpope/vim-obsession' -- Automatic session management
  use 'tpope/vim-surround' -- Add "surroundings text-object cammands"

  -- Keybindings for commening/uncommenting
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }

  use 'tommcdo/vim-exchange' -- cx-<motion> or cxx (line)/X (visual) for swapping text objects (cxc to clear)

  -- Material colort theme
  use {
    'kaicataldo/material.vim', 
    branch = 'main',
    setup = function()
      vim.g['material_theme_style'] = 'darker'
      vim.g['material_terminal_italics'] = 1
      vim.cmd('colorscheme material')
    end
  }

  use 'Yggdroot/indentLine' -- Display thin vertical lines at each indentation level for code indented with spaces
  use {
  -- 'vim-test/vim-test',
    'MrcJkb/vim-test',
    branch = 'stacktest-improvements',
    setup = function()
    vim.g['test#strategy'] = 'neovim'
    vim.g['test#java#runner'] = 'gradletest'
    vim.g['test#haskell#runner'] = 'stacktest'
    vim.g['g:test#haskell#stacktest#file_pattern'] = [[\v^(.*spec.*|.*test.*)\c\.hs$']]
  end
  }
  use {
    "klen/nvim-test",
    config = function()
      require('nvim-test').setup {
        commands_create = false,
      }
    end,
    setup = function()
      vim.api.nvim_command "command! TstFile lua require'nvim-test'.run('file')<CR>"
      vim.api.nvim_command "command! TstLast lua require'nvim-test'.run_last()<CR>"
      vim.api.nvim_command "command! TstNearest lua require'nvim-test'.run('nearest')<CR>"
      vim.api.nvim_command "command! TstSuite lua require'nvim-test'.run('suite')<CR>"
      vim.api.nvim_command "command! TstVisit lua require'nvim-test'.visit()<CR>"
      vim.api.nvim_command "command! TstInfo lua require'nvim-test.info'()<CR>"
      vim.api.nvim_command "command! TstEdit lua require'nvim-test'.edit()<CR>"
      -- require('nvim-test.runners.hspec'):setup {
      -- }
    end,
  }

  use {
    'neovim/nvim-lspconfig',
    config = function()
      require('lsp-overrides').setup()
      require('lspconfig-setup')
    end

  }
  use 'nvim-lua/lsp-status.nvim' -- LSP status line info
  use 'ray-x/lsp_signature.nvim' -- LSP autocomplete signature hints

  -- LSP floating popups, etc.
  use {
    'RishabhRD/nvim-lsputils',
    requires = {
      'RishabhRD/popfix'
    }
  }

  use 'onsails/lspkind-nvim' -- Autocomplete icons
  use {
    'hrsh7th/nvim-cmp', -- Completion plugin
    config = function()
      require('completion-config')
    end
  }
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'quangnguyen30192/cmp-nvim-ultisnips'

  use 'hrsh7th/vim-vsnip' -- VSCode vsnip for use with LSP autocomplete
  use 'hrsh7th/vim-vsnip-integ'

  use { 
    'folke/zen-mode.nvim', -- Adds a :ZenMode
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>z', ':ZenMode<Cr>', { noremap = true, silent = true })
      require("zen-mode").setup( {
          backdrop = 1,
        })
    end
  }

  use { 
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('treesitter-config')
    end
  }
  use 'nvim-treesitter/nvim-treesitter-textobjects' -- Treesitter-based text objects
  use 'p00f/nvim-ts-rainbow' -- Rainbow brackets (needs nvim-treesitter)
  use 'nvim-treesitter/nvim-treesitter-refactor'

  use {
    'folke/twilight.nvim', -- Dim inactive potions of code (powered by TreeSitter)
    config = function()
      require('twilight-config')
    end
  }

  use 'mfussenegger/nvim-jdtls' -- Java LSP support
  use {
    'mfussenegger/nvim-dap', -- Debug Adapter Protocol
    config = function()
      require('dap-setup')
    end
  }
  use 'mfussenegger/nvim-dap-python'
  -- use {
  --   'mfusenegger/nvim-lint',
  --   config = function()
  --     require('lint').linters_by_ft = {
  --       haskell = {'hie',}
  --     }
  --   end,
  -- }
  use 'theHamsta/nvim-dap-virtual-text'
  use 'rcarriga/nvim-dap-ui'
  use 'jbyuki/one-small-step-for-vimkind' -- Debug Adapter for neovim/lua

  -- use {'ShinKage/idris2-nvim', requires = {'neovim/nvim-lspconfig', 'MunifTanjim/nui.nvim'}}

  use {
    'simrat39/rust-tools.nvim',
  }

  use 'norcalli/snippets.nvim' -- Snippet support
  use { 
    'SirVer/ultisnips',
    setup = function()
      vim.g['UltiSnipsSnippetDirectories'] = {"UltiSnips", "ultisnips"}
    end
  }

  use {
    'nvim-lua/popup.nvim',
    requires = { 'nvim-lua/plenary.nvim' }
  }

  use {
    'nvim-telescope/telescope.nvim',
    config = function()
      require('telescope-config')
    end
  }
  use 'nvim-telescope/telescope-fzy-native.nvim'
  use 'fhill2/telescope-ultisnips.nvim'
  use {
    'luc-tielen/telescope_hoogle',
    -- run = 'hoogle generate',
  }
  use {
    'nvim-telescope/telescope-cheat.nvim',
    requires = { 'tami5/sqlite.lua' },
    setup = function() 
      vim.cmd [[
        let g:sqlite_clib_path = $LIBSQLITE_CLIB_PATH
      ]]
    end,
  }

  use 'tjdevries/nlua.nvim' -- Lua development for neovim
  use 'nvim-lua/plenary.nvim' -- Useful lua library
  use 'folke/lua-dev.nvim' -- Lua development for neovim

  -- Fuzzy search
  use {
    'junegunn/fzf',
    run = './install --all'
  }
  use 'junegunn/fzf.vim'

  use 'junegunn/vim-easy-align' -- Formatting, e.g for formatting markdown tables

  -- Activate table mode with :TableModeToggle from insert mode
  use {
    'dhruvasagar/vim-table-mode',
    setup = function()
      vim.g['table_mode_corner'] = '+'
      vim.g['table_mode_corner_corner'] = '+'
      vim.g['table_mode_header_fillchar'] = '='
    end,
    -- ft = {'markdown'}
  }

  use {
    'hoob3rt/lualine.nvim', -- Status line at the bottom
    config = function()
      require('lualine-setup')
    end
  }
  use 'SmiteshP/nvim-gps' -- Status line component that shows context of the current cursor position in the file - used with lualine
  
  -- rangr client
  use {
    'kevinhwang91/rnvimr', 
  }

  use 'kyazdani42/nvim-web-devicons'
  use 'ryanoasis/vim-devicons'

  -- Wrapper for toggling NeoVim terminals
  use {
    "akinsho/toggleterm.nvim",
    config = function()
      require('toggleterm-setup')
    end
  }

  -- Specify, or on the fly, mark and create persisting key strokes to go to the files you want.
  -- + Unlimiter terminals and navigation
  use {
    'ThePrimeagen/harpoon',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('harpoon-config').setup()
    end
  }

  use {
    'windwp/nvim-autopairs',
    config = function()
      require('autopairs-config')
    end
  }

  -- Virtual text with git blame information, etc
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('gitsigns').setup({
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
              if vim.wo.diff then return ']g' end
              vim.schedule(function() gs.next_hunk() end)
              return '<Ignore>'
            end, {expr=true})

            map('n', '[g', function()
              if vim.wo.diff then return '[g' end
              vim.schedule(function() gs.prev_hunk() end)
              return '<Ignore>'
            end, {expr=true})

            -- Actions
            map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
            map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
            map('n', '<leader>hS', gs.stage_buffer)
            map('n', '<leader>hu', gs.undo_stage_hunk)
            map('n', '<leader>hR', gs.reset_buffer)
            map('n', '<leader>hp', gs.preview_hunk)
            map('n', '<leader>hb', function() gs.blame_line{full=true} end)
            map('n', '<leader>tb', gs.toggle_current_line_blame)
            map('n', '<leader>hd', gs.diffthis)
            map('n', '<leader>hD', function() gs.diffthis('~') end)
            map('n', '<leader>td', gs.toggle_deleted)
            -- Text object
            map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
          end,
        })
    end
  }

end)
