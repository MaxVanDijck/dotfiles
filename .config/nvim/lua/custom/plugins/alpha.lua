return {
  "goolord/alpha-nvim",
  event = "VimEnter", -- load plugin after all configuration is set
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Add vertical buffering at the top
    local header_padding = math.floor(vim.fn.winheight(0) * 0.2)
    local padding_lines = {}
    for i = 1, header_padding do
      table.insert(padding_lines, "")
    end
    dashboard.section.header.val = padding_lines

    _Gopts = {
      position = "center",
      hl = "Type",
      -- wrap = "overflow";
    }

    -- Set menu
    dashboard.section.buttons.val = {
      dashboard.button("f", "󰱼   Find file", ":Telescope find_files<CR>"),
      dashboard.button("w", "   Find word", ":Telescope live_grep<CR>"),
      dashboard.button("g", "   Git", ":tab G<CR>"),
      dashboard.button("c", "   Config", ":e $MYVIMRC <CR>"),
      dashboard.button("m", "󱌣   Mason", ":Mason<CR>"),
      dashboard.button("l", "󰒲   Lazy", ":Lazy<CR>"),
      dashboard.button("q", "   Quit NVIM", ":qa<CR>"),
    }


    dashboard.opts.opts.noautocmd = true
    alpha.setup(dashboard.opts)

    require('alpha').setup(dashboard.opts)

    vim.api.nvim_create_autocmd('User', {
      pattern = 'LazyVimStarted',
      callback = function()
        local stats = require('lazy').stats()
        local count = (math.floor(stats.startuptime * 100) / 100)
        dashboard.section.footer.val = {
          "󱐌 " .. stats.count .. " plugins loaded in " .. count .. " ms",
        }
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
