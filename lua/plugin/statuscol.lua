local statuscol = {}

statuscol.config = function()
  require('statuscol').setup {
    setopt = true,
    relculright = true,
  }
end

return statuscol
