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
    theme = 'material-nvim',
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
