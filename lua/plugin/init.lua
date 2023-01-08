-- Bootstrap packer for new installations
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap = false
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd.packadd('packer.nvim')
  packer_bootstrap = true
end

return require('packer').startup(function(use)
  use {
    'lewis6991/impatient.nvim',
  }

  use('wbthomason/packer.nvim')

  use {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
  }

  use {
    'toppair/peek.nvim',
    run = 'deno task --quiet build:fast',
    config = function()
      vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
      vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})
    end,
    -- FIXME
    ft = 'markdown',
  }

  use { 'ellisonleao/glow.nvim', cmd = 'Glow' }

  -- CamelCase, snake_case, etc word motions
  use {
    'chaoren/vim-wordmotion',
    setup = function()
      -- Use Alt as prefix for word motion mappings
      vim.g.wordmotion_mappings = {
        ['w'] = '<M-w>',
        ['b'] = '<M-b>',
        ['e'] = '<M-e>',
        ['ge'] = 'g<M-e>',
        ['aw'] = 'a<M-w>',
        ['iw'] = 'i<M-w>',
        ['<C-R><C-W>'] = '<C-R><M-w>',
      }
    end,
  }

  -- Highlight colours (e.g. #800080)
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      vim.schedule(function()
        require('colorizer').setup()
      end)
    end,
  }

  -- Remaps s [cl] and S [cc] to vertical leap search
  use {
    'ggandor/leap.nvim',
    config = function()
      require('leap').set_default_keymaps()
    end,
  }

  -- Highlight unique characters in line search
  use {
    'unblevable/quick-scope',
    setup = function()
      vim.g.qs_highlight_on_keys = { 'f', 'F', 't', 'T' }
    end,
  }

  -- User-defined textobjects
  use('kana/vim-textobj-user')

  -- .editorconfig support
  use('gpanders/editorconfig.nvim')

  -- NeoVim clone of Magit
  use {
    'TimUntersberger/neogit',
    requires = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
    },
    config = function()
      require('plugin.neogit')
    end,
  }

  -- Git wrapper
  use('tpope/vim-fugitive')
  use('tpope/vim-rhubarb') -- GitHub fugitive plugin for :GBrowse
  use {
    'shumphrey/fugitive-gitlab.vim', -- GitLab fugitive support for :GBrowse
    setup = function()
      vim.g.fugitive_gitlab_domains = { 'ssh://gitlab.internal.tiko.ch', 'https://gitlab.internal.tiko.ch' }
    end,
  }

  -- Add repeat . support to custom commands
  use('tpope/vim-repeat')
  -- Navigation with [ and ] keybindings
  use('tpope/vim-unimpaired')
  use {
    'tpope/vim-dispatch',
    cmd = { 'Dispatch', 'Make', 'Focus', 'Start' }, -- lazy-load on specific commands
  }

  use {
    'kylechui/nvim-surround', -- Add 'surroundings text-object cammands'
    config = function()
      require('nvim-surround').setup {}
    end,
  }

  use {
    'folke/persistence.nvim',
    module = 'persistence',
    config = function()
      require('plugin.persistence')
    end,
  }

  -- Keybindings for commening/uncommenting
  use {
    'numToStr/Comment.nvim',
    config = function()
      vim.schedule(function()
        require('Comment').setup()
      end)
    end,
  }

  use {
    'JoosepAlviste/nvim-ts-context-commentstring',
    config = function()
      require('nvim-treesitter.configs').setup {
        context_commentstring = {
          enable = true,
        },
      }
    end,
  }

  use('tommcdo/vim-exchange') -- cx-<motion> or cxx (line)/X (visual) for swapping text objects (cxc to clear)

  -- Material color theme
  use {
    'marko-cerovac/material.nvim',
    branch = 'main',
    setup = require('plugin.theme').setup,
    config = require('plugin.theme').config,
  }

  use {
    'nvim-neotest/neotest',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'MrcJkb/neotest-haskell',
      'nvim-neotest/neotest-python',
      'nvim-neotest/neotest-plenary',
      'rouge8/neotest-rust',
    },
    config = function()
      require('plugin.neotest')
    end,
  }

  use {
    'neovim/nvim-lspconfig',
    requires = {
      'MrcJkb/haskell-tools.nvim',
      'simrat39/rust-tools.nvim',
      'simrat39/inlay-hints.nvim',
      'mfussenegger/nvim-jdtls', -- Java LSP support
      'folke/neodev.nvim', -- Lua development for neovim
      -- 'ShinKage/idris2-nvim',
      -- 'MunifTanjim/nui.nvim', -- Required by idris2-nvim

      -- Debug Adapter Protocol
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'jbyuki/one-small-step-for-vimkind', -- Debug Adapter for neovim/lua

      -- Additional plugins used in lsp.lua
      'nvim-lua/lsp-status.nvim', -- LSP status line info
      'ray-x/lsp_signature.nvim', -- LSP autocomplete signature hints
      'camilledejoye/nvim-lsp-selection-range', -- LSP selection range
      'kosayoda/nvim-lightbulb',
    },
    setup = function()
      vim.fn.sign_define('LightBulbSign', { text = '', texthl = 'LspDiagnosticsDefaultInformation' })
    end,
    config = function()
      require('plugin.dap')
      require('plugin.lsp')
    end,
  }

  use {
    'MrcJkb/lsp-inject.nvim',
  }

  use {
    'hrsh7th/nvim-cmp', -- Completion plugin
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-document-symbol',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-omni',
      'quangnguyen30192/cmp-nvim-ultisnips',
      'petertriho/cmp-git',
      'lukas-reineke/cmp-rg',
      'onsails/lspkind-nvim', -- Autocomplete icons
      'rcarriga/cmp-dap',
      -- 'amarakon/nvim-cmp-buffer-lines',
      'davidsierradz/cmp-conventionalcommits',
      'dmitmel/cmp-cmdline-history',
    },
    setup = function()
      vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
    end,
    config = function()
      vim.schedule(function()
        require('plugin.completion')
      end)
    end,
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    requires = {
      'nvim-treesitter/playground',
      'nvim-treesitter/nvim-treesitter-textobjects',
      -- 'MrcJkb/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-context',
      'nvim-treesitter/nvim-treesitter-refactor',
      'p00f/nvim-ts-rainbow', -- Rainbow brackets (needs nvim-treesitter)
    },
    config = function()
      vim.schedule(function()
        require('plugin.treesitter')
      end)
    end,
  }

  use {
    'mfussenegger/nvim-lint',
    config = function()
      require('plugin.lint')
    end,
  }

  use {
    'SirVer/ultisnips',
    setup = function()
      vim.g.UltiSnipsSnippetDirectories = { 'UltiSnips', 'ultisnips' }
    end,
  }

  use {
    'L3MON4D3/LuaSnip',
    config = function()
      require('plugin.luasnip')
    end,
  }

  use {
    'nvim-lua/popup.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    ft = 'lua',
  }

  use {
    -- Project management
    -- Changes the working directory to the project root when you open a file or directory.
    'ahmedkhalf/project.nvim',
    config = function()
      require('plugin.project')
    end,
  }

  use {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    requires = {
      'luc-tielen/telescope_hoogle',
      'MrcJkb/telescope-manix',
      'nvim-telescope/telescope-fzy-native.nvim',
      'nvim-telescope/telescope-smart-history.nvim',
      'nvim-telescope/telescope-cheat.nvim',
      'tami5/sqlite.lua', -- Required by smart-history and cheat
      'cljoly/telescope-repo.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
    },
    setup = function()
      vim.g.sqlite_clib_path = require('luv').os_getenv('LIBSQLITE')
    end,
    config = function()
      vim.schedule(function()
        require('plugin.telescope')
      end)
    end,
  }

  use {
    'folke/todo-comments.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('todo-comments').setup()
    end,
  }

  -- proviedes lua scratch pad
  use { 'bfredl/nvim-luadev' }

  -- Fuzzy search
  use {
    'junegunn/fzf',
    requires = {
      'junegunn/fzf.vim',
    },
    run = './install --all',
  }

  use {
    'hoob3rt/lualine.nvim', -- Status line at the bottom
    requires = {
      -- Status line component that shows context of the current cursor position in the file
      'SmiteshP/nvim-gps',
    },
    config = function()
      if vim.g.started_by_firenvim then
        vim.cmd.set('laststatus=0')
      else
        require('plugin.lualine')
      end
    end,
  }

  -- rangr client
  use {
    'kevinhwang91/rnvimr',
    setup = function()
      require('plugin.rnvimr')
    end,
  }

  -- Edit directories in a buffer. :Dirbuf
  use {
    'elihunter173/dirbuf.nvim',
    config = function()
      require('dirbuf').setup {}
    end,
  }

  use('kyazdani42/nvim-web-devicons')
  use('ryanoasis/vim-devicons')

  -- Wrapper for toggling NeoVim terminals
  use {
    'akinsho/toggleterm.nvim',
    config = function()
      require('plugin.toggleterm')
    end,
  }

  -- Specify, or on the fly, mark and create persisting key strokes to go to the files you want.
  -- + Unlimiter terminals and navigation
  -- use {
  --   'ThePrimeagen/harpoon',
  --   requires = { 'nvim-lua/plenary.nvim' },
  --   config = function()
  --     require('plugin.harpoon').setup()
  --   end
  -- }

  -- Virtual text with git blame information, etc
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('plugin.gitsigns')
    end,
  }

  use { -- better quickfix list
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
  }

  use {
    'mhartington/formatter.nvim',
    config = function()
      require('plugin.formatter')
    end,
  }

  use {
    'gbprod/yanky.nvim',
    requires = { 'kkharji/sqlite.lua' },
    config = function()
      require('plugin.yanky')
    end,
  }

  use {
    'hkupty/iron.nvim',
    config = function()
      require('plugin.repl')
    end,
  }

  use {
    'jbyuki/venn.nvim',
    config = function()
      require('venn')
    end,
  }

  use {
    -- Leverages Neovim's built-in RPC functionality to simplify opening files from
    -- within Neovim's terminal emulator without unintentionally nesting sessions.
    'samjwill/nvim-unception',
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
