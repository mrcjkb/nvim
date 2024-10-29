require('catppuccin').setup {
  no_italic = true,
  term_colors = true,
  transparent_background = false,
  ---@type CtpFlavors<CtpColors<string>>
  color_overrides = {
    ---@class CtpColors<string>
    mocha = {
      base = '#202020',
      mantle = '#202020',
      crust = '#202020',
    },
  },
  ---@param colors CtpColors<string>
  custom_highlights = function(colors)
    local darkening_percentage = 0.095
    local U = require('catppuccin.utils.colors')
    return {
      TelescopeResultsTitle = { bg = colors.green, fg = colors.base },
      TelescopePromptTitle = { bg = colors.yellow, fg = colors.base },
      TelescopePreviewTitle = { bg = colors.red, fg = colors.base },
      TermCursor = { link = 'Cursor' },
      TermCursorNC = { bg = colors.red, fg = colors.text, ctermbg = 1, ctermfg = 15 },
      LspCodeLens = { fg = colors.mauve, bg = U.darken(colors.mauve, darkening_percentage, colors.base), italic = true },
      FidgetTitle = { link = 'DiagnosticHint' },
    }
  end,
  integrations = {
    fidget = true,
    flash = true,
    fzf = false,
    harpoon = true,
    indent_blankline = { enabled = true },
    cmp = false,
    gitsigns = true,
    nvimtree = false,
    notify = false,
    mini = { enabled = false },
    mason = false,
    markdown = true,
    neogit = true,
    neotest = true,
    dap = false,
    dap_ui = false,
    semantic_tokens = true,
    nvim_surround = true,
    treesitter = true,
    treesitter_context = true,
    ts_rainbow2 = true,
    ufo = true,
    which_key = true,
    vimwiki = true,
    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
  },
}
vim.cmd.colorscheme('catppuccin')

-- XXX: lualine needs to be setup after setting the colorscheme

---@return string status
local function extra_mode_status()
  local reg_recording = vim.fn.reg_recording()
  if reg_recording ~= '' then
    return ' @' .. reg_recording
  end
  local reg_executing = vim.fn.reg_executing()
  if reg_executing ~= '' then
    return ' @' .. reg_executing
  end
  local mode = vim.api.nvim_get_mode().mode
  if mode == 'ix' then
    return '^X: (^]^D^E^F^I^K^L^N^O^Ps^U^V^Y)'
  end
  return ''
end

local flavour = 'mocha'
local catppuccin = require('catppuccin.utils.lualine')(flavour)
local C = require('catppuccin.palettes').get_palette(flavour)
catppuccin.normal.a.bg = C.mauve
catppuccin.visual.a.bg = C.blue

require('lualine').setup {
  globalstatus = true,
  sections = {
    lualine_c = {
      {
        function(...)
          require('nvim-navic').get_location(...)
        end,
        cond = function(...)
          require('nvim-navic').is_available(...)
        end,
      },
    },
    lualine_z = {
      { extra_mode_status },
    },
  },
  options = {
    theme = catppuccin,
  },
  tabline = {
    lualine_a = {
      {
        'tabs',
        mode = 1,
      },
    },
    lualine_b = {
      {
        'buffers',
        show_filename_only = true,
        show_bufnr = true,
        mode = 4,
        filetype_names = {
          TelescopePrompt = 'Telescope',
          dashboard = 'Dashboard',
          packer = 'Packer',
          fzf = 'FZF',
          alpha = 'Alpha',
        },
        buffers_color = {
          -- Same values as the general color option can be used here.
          active = 'lualine_b_normal', -- Color for active buffer.
          inactive = 'lualine_b_inactive', -- Color for inactive buffer.
        },
      },
    },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  winbar = {
    lualine_z = {
      {
        'filename',
        path = 1,
        file_status = true,
        newfile_status = true,
      },
    },
  },
  extensions = { 'fugitive', 'fzf', 'toggleterm', 'quickfix' },
}
