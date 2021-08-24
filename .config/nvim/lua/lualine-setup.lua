local gps = require("nvim-gps")
gps.setup()
require("lualine").setup({
        sections = {
            lualine_c = {
                { 
                    gps.get_location, 
                    condition = gps.is_available,
                },
            }
        },
        options = { 
            theme = "material",
        },
    })
