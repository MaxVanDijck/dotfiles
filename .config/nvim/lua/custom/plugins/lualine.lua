return {
'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      name = "lualine",
      lazy = false,
-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
config = function()
local lualine = require('lualine')

-- Color table for highlights
-- stylua: ignore
local color = {
	rosewater = "#f5e0dc",
	flamingo = "#f2cdcd",
	pink = "#f5c2e7",
	mauve = "#cba6f7",
	red = "#f38ba8",
	maroon = "#eba0ac",
	peach = "#fab387",
	yellow = "#f9e2af",
	green = "#a6e3a1",
	teal = "#94e2d5",
	sky = "#89dceb",
	sapphire = "#74c7ec",
	blue = "#89b4fa",
	lavender = "#b4befe",
	text = "#cdd6f4",
	subtext1 = "#bac2de",
	subtext0 = "#a6adc8",
	overlay2 = "#9399b2",
	overlay1 = "#7f849c",
	overlay0 = "#6c7086",
	surface2 = "#585b70",
	surface1 = "#45475a",
	surface0 = "#313244",
	base = "#1e1e2e",
	mantle = "#181825",
	crust = "#11111b",
}

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')

    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

-- Config
local config = {
  options = {
    -- Disable sections and component separators
    component_separators = '',
    section_separators = '',
    theme = {
      -- We are going to use lualine_c an lualine_x as left and
      -- right section. Both are highlighted by c theme .  So we
      -- are just setting default looks o statusline
      normal = { c = { bg = color.surface0 } },
      inactive = { c = { bg = color.surface0 } },
    },
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- These will be filled later
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x at right section
local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

--  ins_left {
--    function()
--      return '▊'
--    end,
--    color = { fg = colors.darkblue }, -- Sets highlighting of component
--    padding = { left = 0, right = 1 }, -- We don't need space before this
--  }
 
 ins_left {
   -- mode component
   function()
     return ''
   end,
   color = function()
     -- auto change color according to neovims mode
     local mode_color = {
       n = color.red,
       i = color.green,
       v = color.blue,
       [''] = color.blue,
       V = color.blue,
       c = color.magenta,
       no = color.red,
       s = color.orange,
       S = color.orange,
       [''] = color.orange,
       ic = color.yellow,
       R = color.violet,
       Rv = color.violet,
       cv = color.red,
       ce = color.red,
       r = color.teal,
       rm = color.teal,
       ['r?'] = color.teal,
       ['!'] = color.red,
       t = color.red,
     }
     return { fg = mode_color[vim.fn.mode()] }
   end,
   padding = { left=1, right = 1 },
 }
-- 
--  ins_left {
--    -- filesize component
--    'filesize',
--    cond = conditions.buffer_not_empty,
--  }
-- 
 ins_left {
   'filename',
   cond = conditions.buffer_not_empty,
   color = { fg = color.violet },
 }


 ins_left {
   'branch',
   icon = '',
   color = { fg = color.lavendar, gui = 'bold' },
 }

 ins_left {
   'diff',
   -- Is it me or the symbol for modified us really weird
   symbols = { added = '󰐕 ', modified = ' ', removed = '󰍴 ' },
   diff_color = {
     added = { fg = color.green },
     modified = { fg = color.orange },
     removed = { fg = color.red },
   },
 }
-- 
-- ins_left { 'location' }
-- 
-- 
 ins_right {
   'diagnostics',
   sources = { 'nvim_diagnostic' },
   symbols = { error = ' ', warn = ' ', info = ' ' },
   diagnostics_color = {
     color_error = { fg = color.red },
     color_warn = { fg = color.yellow },
     color_info = { fg = color.teal },
   },
 }
-- 
-- -- Insert mid section. You can make any number of sections in neovim :)
-- -- for lualine it's any number greater then 2
-- ins_left {
--   function()
--     return '%='
--   end,
-- }
-- 
 ins_right {
   -- Lsp server name .
   function()
     local msg = 'No Active Lsp'
     local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
     local clients = vim.lsp.get_active_clients()
     if next(clients) == nil then
       return msg
     end
     for _, client in ipairs(clients) do
       local filetypes = client.config.filetypes
       if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
         return client.name
       end
     end
     return msg
   end,
   icon = '  LSP:',
   color = { fg = color.blue, gui = 'bold' },
 }

ins_right {

function()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
end,
  icon = '󰉋',
   color = { fg = color.blue, gui = 'bold' },
}

ins_right { 
	'progress', 
	color = { fg = color.fg, gui = 'bold' } 
}

lualine.setup(config)
end
}
