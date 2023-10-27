require('project_nvim').setup {
  patterns = {
    '.envrc',
    '.git',
    '_darcs',
    '.hg',
    '.bzr',
    '.svn',
    'flake.nix',
    'Makefile',
    'package.json',
    'cabal.project',
    'stack.yaml',
    'hie.yaml',
  },
  scope_chdir = 'win',
}
