require('lz.n').load {
  'nomad',
  cmd = 'Mad',
  after = function()
    require('nomad').setup()
  end,
}
