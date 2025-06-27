return {
  "akinsho/bufferline.nvim",
  name = "bufferline",
  version = "*",
  lazy = false,
  config = function()
    local bufferline = require('bufferline')
    bufferline.setup {
      options = {
        themeable = true,
        separator_style = "thin",
        show_buffer_close_icons = false,
      },
    }
  end,
}
