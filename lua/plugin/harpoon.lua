local harpoon = {}

function harpoon.config()
  local home = os.getenv('HOME')
  local git_home = home .. '/git'
  local github_home = git_home .. '/github'
  local github_mrcjkb = github_home .. '/mrcjkb'
  local nix_flake_check_cmd = 'nix flake check -L'

  require('harpoon').setup {
    projects = {
      [github_mrcjkb .. '/nvim-config'] = {
        term = {
          cmds = {
            nix_flake_check_cmd,
          },
        },
      },
    },
  }

  local function nnoremap(keybinding, cmd)
    vim.keymap.set('n', keybinding, cmd, { noremap = true, silent = true })
  end

  local mark = require('harpoon.mark')
  local ui = require('harpoon.ui')
  local cmd_ui = require('harpoon.cmd-ui')
  nnoremap('<leader>hm', mark.add_file)
  nnoremap('<leader>ht', ui.toggle_quick_menu)
  nnoremap('<leader>hc', cmd_ui.toggle_quick_menu)
  nnoremap('[h', ui.nav_prev)
  nnoremap(']h', ui.nav_next)
end

return harpoon
