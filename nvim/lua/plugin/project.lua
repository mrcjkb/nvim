require('project_nvim').setup {
  patterns = {
    '.git',
    '_darcs',
    '.hg',
    '.bzr',
    '.svn',
    'Makefile',
    'package.json',
    'cabal.project',
    'stack.yaml',
    'hie.yaml',
  },
  scope_chdir = 'win',
}
