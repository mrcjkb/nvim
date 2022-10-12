-- Bootstrap packer for new installations
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local packer_bootstrap = false;
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

return require('packer').startup(function(use)

  use {
    'lewis6991/impatient.nvim',
    config = function()
      require('impatient')
    end,
  }

  use 'wbthomason/packer.nvim'

  use {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
  }

  -- use 'MrcJkb/nvim-java-tsls'
  -- use 'MrcJkb/autofix.nvim'

  -- lazy loaded

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

  use {'ellisonleao/glow.nvim', cmd = 'Glow'}

  -- CamelCase, snake_case, etc word motions
  use {
    'chaoren/vim-wordmotion',
    setup = function()
      -- Use Alt as prefix for word motion mappings -- FIXME
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

  -- -- Syntax highlighting/indentation
  -- use {
  --   'sheerun/vim-polyglot',
  --   setup = function()
  --     vim.g['polyglot_disabled'] = {'java'}
  --   end
  -- }

  -- Highlight colours (e.g. #800080)
  use {
    'norcalli/nvim-colorizer.lua',
    config = function ()
      vim.schedule(function()
        require'colorizer'.setup()
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
      vim.g.qs_highlight_on_keys = {'f', 'F', 't', 'T'}
    end,
  }

  -- User-defined textobjects
  use 'kana/vim-textobj-user'

  -- .editorconfig support
  use {
  'editorconfig/editorconfig-vim',
  setup = function()
    vim.g.EditorConfig_exclude_patterns = {'fugitive://.*'}
  end,
}

  -- Git wrapper
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb' -- GitHub fugitive plugin for :GBrowse
  use 'tommcdo/vim-fubitive' -- Bitbucket fugitive plugin for :GBrowse
  use {
    'shumphrey/fugitive-gitlab.vim', -- GitLab fugitive support for :GBrowse
    setup = function()
      vim.g.fugitive_gitlab_domains = {'ssh://gitlab.internal.tiko.ch', 'https://gitlab.internal.tiko.ch'}
    end,
  }

  -- Add repeat . suppor to custom commands
  use 'tpope/vim-repeat'
  -- Vim sugar for UNIX shell commands (:Move, :Mkdir, :SudoWrite, etc.)
  use 'tpope/vim-eunuch'
  use {
    'tpope/vim-projectionist', -- alternate file configs
    -- setup = function()
    --   vim.g['projectionist_heuristics'] = {
    --     ['src/**/*.hs'] = {
    --       -- FIXME: Alternate files not detected
    --       ['alternate'] = { 'test/{}Spec.hs',  'test/{}Test.hs' },
    --       ['type'] = 'source',
    --     },
    --     ['*.hs'] = {
    --       ['dispatch'] = 'stack ghci {file}'
    --     },
    --   }
    -- end,
  }
  -- Navigation with [ and ] keybindings
  use 'tpope/vim-unimpaired'
  use {
    'tpope/vim-dispatch',
    cmd = {'Dispatch', 'Make', 'Focus', 'Start'}, -- lazy-load on specific commands
  }
  use 'tpope/vim-obsession' -- Automatic session management
  use 'tpope/vim-surround' -- Add "surroundings text-object cammands"

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
      require'nvim-treesitter.configs'.setup {
        context_commentstring = {
          enable = true
        }
      }
    end,
  }

  use 'tommcdo/vim-exchange' -- cx-<motion> or cxx (line)/X (visual) for swapping text objects (cxc to clear)

  -- Material colort theme
  use {
    'kaicataldo/material.vim', -- TODO: Package for nix
    branch = 'main',
    setup = function()
      vim.g.material_theme_style = 'darker'
      vim.g.material_terminal_italics = 1
    end,
    config = function()
      vim.cmd('colorscheme material')
    end,
  }

  -- use 'Yggdroot/indentLine' -- Display thin vertical lines at each indentation level for code indented with spaces
  use {
    'git@github.com:vim-test/vim-test',
    -- 'git@github.com:MrcJkb/vim-test',
    -- branch = 'stacktest-improvements',
    setup = function()
      vim.g['test#strategy'] = 'neovim'
      vim.g['test#java#runner'] = 'gradletest'
      vim.g['test#haskell#runner'] = 'stacktest'
      -- vim.g['test#haskell#stacktest#file_pattern'] = [[\v^(.*spec.*|.*test.*)\c\.hs$']]
    end,
  }

  use {
    "nvim-neotest/neotest",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "MrcJkb/neotest-haskell",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-plenary",
      "rouge8/neotest-rust",
      -- "nvim-neotest/neotest-vim-test",
    },
    config = function()
      require('neotest-config')
    end,
  }

  use {
    'neovim/nvim-lspconfig',
    requires = {
      'simrat39/rust-tools.nvim',
      'mfussenegger/nvim-jdtls', -- Java LSP support
      'tjdevries/nlua.nvim', -- Lua development for neovim
      -- 'ShinKage/idris2-nvim',
      -- 'MunifTanjim/nui.nvim', -- Required by idris2-nvim

      -- Debug Adapter Protocol
      'mfussenegger/nvim-dap',
      'mfussenegger/nvim-dap-python',
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'jbyuki/one-small-step-for-vimkind', -- Debug Adapter for neovim/lua

      -- Additional plugins used in lspconfig-setup
      'nvim-lua/lsp-status.nvim', -- LSP status line info
      'ray-x/lsp_signature.nvim', -- LSP autocomplete signature hints
    },
    config = function()
      require('dap-setup')
      require('lspconfig-setup')
      require('lsp-overrides').setup()
    end,
  }

  use {
    'kosayoda/nvim-lightbulb',
    requires = 'antoinemadec/FixCursorHold.nvim',
    config = function()
      require('nvim-lightbulb').setup({autocmd = {enabled = true}})
    end,
  }

  -- LSP floating popups, etc.
  use {
    'RishabhRD/nvim-lsputils',
    requires = {
      'RishabhRD/popfix',
    },
  }

  use {
    'hrsh7th/nvim-cmp', -- Completion plugin
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-nvim-lsp',
      'quangnguyen30192/cmp-nvim-ultisnips',
      'hrsh7th/vim-vsnip', -- VSCode vsnip for use with LSP autocomplete
      'hrsh7th/vim-vsnip-integ',
      'petertriho/cmp-git',
      'lukas-reineke/cmp-rg',
      'onsails/lspkind-nvim', -- Autocomplete icons
    },
    config = function()
      vim.schedule(function()
        require('completion-config')
      end)
      vim.cmd('set completeopt=menu,menuone,noselect') 
      --Avoid showing message extra message when using completion
      -- vim.cmd 'set shortmess+=c'
    end,
  }

  use {
    'folke/zen-mode.nvim', -- Adds a :ZenMode
    config = function()
      vim.schedule(function()
        vim.api.nvim_set_keymap('n', '<leader>z', ':ZenMode<Cr>', { noremap = true, silent = true })
        require("zen-mode").setup( {
          backdrop = 1,
        })
      end)
    end,
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    requires = { 
      'nvim-treesitter/playground'
    },
    config = function()
      vim.schedule(function()
        require('treesitter-config')
        require "nvim-treesitter.configs".setup {
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
            lint_events = {"BufWrite", "CursorHold"},
          },
        }
      end)
    end,
  }
  use 'nvim-treesitter/nvim-treesitter-textobjects' -- Treesitter-based text objects
  use 'nvim-treesitter/nvim-treesitter-context' 
  use 'p00f/nvim-ts-rainbow' -- Rainbow brackets (needs nvim-treesitter)
  use 'nvim-treesitter/nvim-treesitter-refactor'

  use {
    'folke/twilight.nvim', -- Dim inactive portions of code (powered by TreeSitter)
    config = function()
      vim.schedule(function()
        require('twilight-config')
      end)
    end,
  }

  use {
    'git@github.com:mfussenegger/nvim-lint.git',
    config = function()
      local lint = require('lint')
      local hlint_hint_file = os.getenv("HLINT_HINT")
      if hlint_hint_file and hlint_hint_file ~= "" then
        lint.linters.hlint.args = { '--json', '--no-exit-code', '--hint=' .. hlint_hint_file}
      end
      lint.linters_by_ft = {
        haskell = {'hlint',}
      }
      vim.api.nvim_create_autocmd('BufWritePost', {
        group = vim.api.nvim_create_augroup('lint-commands', {}),
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  }

  use {
    -- Snippet support
    'norcalli/snippets.nvim',
    config = function ()
      require'snippets'.use_suggested_mappings()
      -- This variant will set up the mappings only for the *CURRENT* buffer.
      -- There are only two keybindings specified by the suggested keymappings, which is <C-k> and <C-j>
      -- They are exactly equivalent to:
      -- <c-k> will either expand the current snippet at the word or try to jump to
      -- the next position for the snippet.
      vim.keymap.set('i', '<c-k>', function()
        return require'snippets'.expand_or_advance(1)
      end, {noremap = true,})
      -- <c-j> will jump backwards to the previous field.
      -- If you jump before the first field, it will cancel the snippet.
      vim.keymap.set('i', '<c-j>', function()
        return require'snippets'.advance_snipped(-1)
      end, {noremap = true,})
    end,
  }

  use {
    'SirVer/ultisnips',
    setup = function()
      vim.g.UltiSnipsSnippetDirectories = {"UltiSnips", "ultisnips"}
    end,
  }

  use {
    'nvim-lua/popup.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    ft = {'lua'},
  }

  use {
    -- Changes the working directory to the project root when you open a file or directory.
    'airblade/vim-rooter',
    setup = function()
      -- Change each buffer’s directory, instead of the whole editor
      vim.g.rooter_cd_cmd = 'lcd'
    end,
  }

  use {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    requires = {
      'luc-tielen/telescope_hoogle', -- TODO: Package for nix
      'MrcJkb/telescope-manix',
      'nvim-telescope/telescope-fzy-native.nvim',
      'nvim-telescope/telescope-smart-history.nvim',
      'nvim-telescope/telescope-cheat.nvim',
      'tami5/sqlite.lua', -- Required by smart-history and cheat
      'cljoly/telescope-repo.nvim',
      'nvim-lua/plenary.nvim',
    },
    setup = function()
      vim.g.sqlite_clib_path = require('luv').os_getenv 'LIBSQLITE'
    end,
    config = function()
      vim.schedule(function()
        require('telescope-config')
      end)
    end,
  }

  use {
    'nvim-lua/plenary.nvim', -- Useful lua library
  }
  use {
    'folke/lua-dev.nvim', -- Lua development for neovim
    config = function()
      require('lua-dev').setup({
        library = { plugins = { 'neotest' }, types = true},
      })
    end,
  }

  -- proviedes lua scratch pad
  use { 'bfredl/nvim-luadev' } -- TODO: Package for nix

  -- Fuzzy search
  use {
    'junegunn/fzf',
    run = './install --all',
  }
  use 'junegunn/fzf.vim'

  use {
    'junegunn/vim-easy-align', -- Formatting, e.g for formatting markdown tables
    ft = {'markdown'},
    setup = function()
      vim.keymap.set('v', '<leader><Bslash>', ':EasyAlign*<Bar><CR>')
    end,
  }

  -- Activate table mode with :TableModeToggle from insert mode
  use {
    'dhruvasagar/vim-table-mode',
    setup = function()
      vim.g.table_mode_corner = '+'
      vim.g.table_mode_corner_corner = '+'
      vim.g.table_mode_header_fillchar = '='
    end,
    ft = {'markdown'},
  }

  use {
    'hoob3rt/lualine.nvim', -- Status line at the bottom
    config = function()
      if vim.g.started_by_firenvim then
        vim.cmd 'set laststatus=0'
      else
        require('lualine-setup')
      end
    end,
  }

  use {
    'SmiteshP/nvim-gps', -- Status line component that shows context of the current cursor position in the file - used with lualine
  }

  -- rangr client
  use {
    'kevinhwang91/rnvimr',
    setup = function()
      -- Do not make Ranger replace netrw and be the file explorer
      vim.g.rnvimr_ex_enable = 0
      -- Make Neovim wipe the buffers corresponding to the files deleted by Ranger
      vim.g.rnvimr_enable_bw = 1
      vim.keymap.set('t', '<M-i>', '<C-\\><C-n>:RnvimrResize<CR>', {silent = true,})
      vim.keymap.set({'n', 't'}, '<M-r>', ':RnvimrToggle<CR>', {silent = true,})
  -- nnrremap <silent> <M-r> :RnvimrToggle<CR>
  -- tnoremap <silent> <M-O> <C-\><C-n>:RnvimrToggle<CR>
      -- Map Rnvimr action
      vim.g.rnvimr_action = {
          ['<C-t>'] = 'NvimEdit tabedit',
          ['<C-x>'] = 'NvimEdit split',
          ['<C-v>'] =  'NvimEdit vsplit',
          ['gw'] =  'JumpNvimCwd',
          ['gf'] = 'AttachFile',
          ['yw'] = 'EmitRangerCwd'
        }
    end,
  }

  -- Edit directories in a buffer. :Dirbuf
  use {
    "elihunter173/dirbuf.nvim",
    config = function()
      require("dirbuf").setup {}
    end,
 }

  use 'kyazdani42/nvim-web-devicons'
  use 'ryanoasis/vim-devicons'

  -- Wrapper for toggling NeoVim terminals
  use {
    "akinsho/toggleterm.nvim",
    config = function()
      vim.schedule(function()
        require('toggleterm-setup')
      end)
    end,
  }

  -- Specify, or on the fly, mark and create persisting key strokes to go to the files you want.
  -- + Unlimiter terminals and navigation
  -- use {
  --   'ThePrimeagen/harpoon',
  --   requires = { 'nvim-lua/plenary.nvim' },
  --   config = function()
  --     require('harpoon-config').setup()
  --   end
  -- }

  use {
    'windwp/nvim-autopairs',
    config = function()
      vim.schedule(function()
        require('autopairs-config')
      end)
    end,
  }

  -- Virtual text with git blame information, etc
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      vim.schedule(function()
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
      end)
    end,
  }

  use {
    'glacambre/firenvim',
    run = function() vim.fn['firenvim#install'](0) end, 
    setup = function()
      vim.g.firenvim_config = {
        globalSettings = {
          alt = 'all';
        },
        localSettings = {
          ['https://app.slack.com/'] = { takover = 'never', priority = 1 }
        },
      }
    end,
    config = function()
      vim.api.nvim_create_autocmd('BufEnter', {
        group = vim.api.nvim_create_augroup('firenvim_gitlab', {}),
        pattern = 'gitlab.internal.tiko.ch_*.txt',
        callback = function() vim.cmd('set filetype=markdown') end
      })
      vim.api.nvim_create_autocmd('BufEnter', {
        group = vim.api.nvim_create_augroup('firenvim_gihub', {}),
        pattern = 'github.com_*.txt',
        callback = function() vim.cmd('set filetype=markdown') end
      })
    end,
  }

  use { -- better quickfix list
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
  }

  if packer_bootstrap then
    require('packer').sync()
    vim.cmd 'TSInstall all'
  end
end)
