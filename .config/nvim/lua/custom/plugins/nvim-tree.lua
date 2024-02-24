return {
  'nvim-tree/nvim-tree.lua',
  lazy = false,
  config = function()
    require('nvim-tree').setup{
      actions = {
        open_file = {
            quit_on_open = true,
        },
      },
      view = {
          adaptive_size = true,
	  side = "left",
        float = {
          enable = true,
          quit_on_focus_loss = true,
        },
        },
    }
  end,
}
