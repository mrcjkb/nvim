-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)

  use 'wbthomason/packer.nvim'

  use 'MrcJkb/nvim-java-tsls'
  use 'MrcJkb/autofix.nvim'

  -- lazy loaded
  -- proviedes lua scratch pad
  use { 'bfredl/nvim-luadev', opt = true, cmd = { 'Luadev' }}

  use { 
    'weirongxu/plantuml-previewer.vim',
    ope = true,
    ft = { 'puml' },
    requires = {
      'tyru/open-browser.vim',
      'aklt/plantuml-syntax',
    }
  }

  use {
    'iamcco/markdown-preview.nvim',
    ft = { 'md' },
    run = ':call mkdp#util#install()'
  }

  -- CamelCase, snake_case, etc word motions
  use 'chaoren/vim-wordmotion'

  -- Syntax/indentation
  use 'sheerun/vim-polyglot'

  -- Highlight colours (e.g. #800080)
  use 'norcalli/nvim-colorizer.lua'

  -- Remaps s [cl] and S [cc] to vertical sneak search
  -- Note: I have it mapped to <M-f> and <M-F>, respectively
  use 'justinmk/vim-sneak'

  -- Highlight unique characters in line search
  use 'unblevable/quick-scope'

  use 'pangloss/vim-javascript'

  -- User-defined textobjects
  use 'kana/vim-textobj-user'

  -- Keybindings for system clipboard copy
  use 'christoomey/vim-system-copy'

  -- .editorconfig support
  use 'editorconfig/editorconfig-vim'

  -- Git wrapper
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb' -- GitHub fugitive plugin for :GBrowse
  use 'tommcdo/vim-fubitive' -- Bitbucket fugitive plugin for :GBrowse
  
  -- Add repeat . suppor to custom commands
  use 'tpope/vim-repeat'

  -- Keybindings for commening/uncommenting
  use 'tpope/vim-commentary'

  -- Navigation with [ and ] keybindings
  use 'tpope/vim-unimpaired'

  use 'tpope/vim-dispatch' 
  use 'tpope/vim-obsession' -- Automatic session management
  use 'udalov/kotlin-vim' -- Highlighting for Kotlin. Also required for Kotlin LSP support
  
  -- Material colort theme
  use {
    'kaicataldo/material.vim', 
    branch = 'main' 
  }

  use 'Yggdroot/indentLine' -- Display thin vertical lines at each indentation level for code indented with spaces
  use 'vim-test/vim-test'
  use {
    'neoclide/coc.nvim',
    branch = 'release'
  }
  use 'neovim/nvim-lspconfig'
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
  use 'hrsh7th/nvim-compe' -- Completion plugin

  use 'hrsh7th/vim-vsnip' -- VSCode vsnip for use with LSP autocomplete
  use 'hrsh7th/vim-vsnip-integ'

  use { 
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use 'nvim-treesitter/nvim-treesitter-textobjects' -- Treesitter-based text objects
  use 'p00f/nvim-ts-rainbow' -- Rainbow brackets (needs nvim-treesitter)

  use 'mfussenegger/nvim-jdtls' -- Java LSP support
  use 'mfussenegger/nvim-dap' -- Debug Adapter Protocol
  use 'mfussenegger/nvim-dap-python'
  use 'theHamsta/nvim-dap-virtual-text'
  use 'rcarriga/nvim-dap-ui'
  use 'jbyuki/one-small-step-for-vimkind' -- Debug Adapter for neovim/lua

  use 'scalameta/nvim-metals' -- Scala LSP support
  use {
    'simrat39/rust-tools.nvim',
  }

  use 'norcalli/snippets.nvim' -- Snippet support
  use 'SirVer/ultisnips'

  use 'nvim-lua/popup.nvim'

  use 'nvim-telescope/telescope.nvim'
  use 'nvim-telescope/telescope-fzy-native.nvim'
  use 'fhill2/telescope-ultisnips.nvim'
  use 'luc-tielen/telescope_hoogle'

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
    ft = { 'md' }
  }

  use { 
    'monkoose/fzf-hoogle.vim',
    ft = { 'hs' }
  }
  
  use 'hoob3rt/lualine.nvim' -- Status line at the bottom
  use 'SmiteshP/nvim-gps' -- Status line component that shows context of the current cursor position in the file - used with lualine
  
  -- rangr client
  use {
    'kevinhwang91/rnvimr', 
    run = 'make sync'
  }

  use 'kyazdani42/nvim-web-devicons'
  use 'ryanoasis/vim-devicons'

end)
