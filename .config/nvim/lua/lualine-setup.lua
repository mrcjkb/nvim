local gps = require("nvim-gps")
gps.setup()
require("lualine").setup({
        globalstatus = true;
        sections = {
            lualine_c = {
                { 
                    'filename',
                    path = 1,
                },
                { gps.get_location, cond = gps.is_available },
            },
        },
        options = { 
            theme = "material",
        },
        tabline = {
            lualine_a = {
                {
                    'tabs',
                    mode = 1,
                }
            },
            lualine_b = {
                {
                    'buffers',
                    show_filename_only = true,
                    mode = 2,
                    filetype_names = {
                        TelescopePrompt = 'Telescope',
                        dashboard = 'Dashboard',
                        packer = 'Packer',
                        fzf = 'FZF',
                        alpha = 'Alpha'
                    },
                    buffers_color = {
                        -- Same values as the general color option can be used here.
                        active = 'lualine_b_normal',     -- Color for active buffer.
                        inactive = 'lualine_b_inactive', -- Color for inactive buffer.
                    },
                },
            },
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {}
        },
        extenstions = {'fugitive', 'fzf', 'toggleterm', 'quickfix', 'chadtree'}
    })
