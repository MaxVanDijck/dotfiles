-- theme catppuccin
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  config = function()
    require('catppuccin').setup {
      -- mostly use defaults from https://github.com/catppuccin/nvim
      transparent_background = true,
    }
    require('catppuccin').load()
  end,
}
