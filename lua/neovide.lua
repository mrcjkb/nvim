if not vim.g.neovide then
  return
end

local font_size = 14
vim.o.guifont = 'JetBrains Mono Nerd Font Mono' .. ':h' .. font_size
vim.g.neovide_hide_mouse_when_typing = true
-- vim.g.neovide_underline_automatic_scaling = true -- Noticeable for font sizes above 15


