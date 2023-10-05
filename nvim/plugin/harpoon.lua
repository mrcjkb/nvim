local home = os.getenv('HOME')
local git_home = home .. '/git'
local github_home = git_home .. '/github'
local github_mrcjkb = github_home .. '/mrcjkb'
local nix_flake_check_cmd = 'nix flake check -L'
local nix_flake_update_cmd = 'nix flake update --commit-lock-file'

require('harpoon').setup {
  projects = {
    [github_mrcjkb .. '/nvim-config'] = {
      term = {
        cmds = {
          nix_flake_check_cmd,
          nix_flake_update_cmd,
        },
      },
    },
  },
}

---@param keybinding string
---@param cmd function | string
---@param description string
local function nnoremap(keybinding, cmd, description)
  vim.keymap.set('n', keybinding, cmd, { noremap = true, silent = true, desc = description })
end

local mark = require('harpoon.mark')
local ui = require('harpoon.ui')
local cmd_ui = require('harpoon.cmd-ui')
nnoremap('<leader>mm', mark.add_file, '[harpoon] mark')
nnoremap('<leader>hm', ui.toggle_quick_menu, '[harpoon] toggle menu')
nnoremap('<leader>hc', cmd_ui.toggle_quick_menu, '[harpoon] toggle command menu')
nnoremap('[h', ui.nav_prev, '[harpoon] previous')
nnoremap(']h', ui.nav_next, '[harpoon] next')
