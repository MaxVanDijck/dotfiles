-- Set <space> as the leader key
-- Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- disable netrw for nvimtree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('lazy_init')
-- Configure plugins
-- Plugins are handled in their individual files
require('lazy').setup({
  import = "custom/plugins"
})

-- [[ Setting options ]]

-- Set highlight on search
vim.o.hlsearch = true

-- Create a user command to show LSP info
vim.api.nvim_create_user_command('LspInfo', function()
  local buf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients({ bufnr = buf })

  if #clients == 0 then
    print("No LSP clients attached to this buffer")
    return
  end

  for _, client in ipairs(clients) do
    print(string.format("LSP: %s (id: %d)", client.name, client.id))
    print(string.format("Root dir: %s", client.config.root_dir or "not set"))
  end
end, {})

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Sync OS and vim clipboards
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
-- Lines that wrap will begin at the same level of indentation
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 750
vim.o.timeoutlen = 300

-- 24 Bit color
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Keymaps for switching between split panes
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>', { silent = true })
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>', { silent = true })
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>', { silent = true })
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>', { silent = true })

-- Diagnostic keymaps
-- TODO: decide weather to use this
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })


-- [[ Configure Telescope ]]
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[F]ile' })
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').live_grep, { desc = '[W]ord' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').git_files, { desc = '[G]it File' })
vim.keymap.set('n', '<leader>fa',
  function() require('telescope.builtin').find_files { hidden = true, no_ignore = true, no_ignore_parent = true } end,
  { desc = '[A]ll files' })
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').current_buffer_fuzzy_find, { desc = 'in [B]uffer' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[H]elp page' })
vim.keymap.set('n', '<leader>fr', require('telescope.builtin').resume, { desc = '[R]esume previous' })

-- LSP
vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions,
  { buffer = bufnr, desc = 'LSP: [G]oto [D]efinition' })
vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references,
  { buffer = bufnr, desc = 'LSP: [G]oto [R]eferences' })
vim.keymap.set('n', '<leader>lrn', vim.lsp.buf.rename, { desc = '[N]ame', noremap = true })


-- [[ Configure Bufferline ]]
vim.keymap.set('n', '<Tab>', ':bnext<CR>', { noremap = true })
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { noremap = true })


-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = {
      -- low level
      'c',
      'cpp',
      'rust',

      -- middle level
      'java',
      'go',
      'kotlin',

      -- high level
      'typescript',
      'tsx',
      'javascript',
      'css',
      'python',

      -- utility
      'sql',
      'bash',
      'cmake',
      'make',
      'cuda',
      'dockerfile',
      'gitattributes',
      'gitignore',
      'json',
      'markdown',
      'hcl',
      'toml',
      'latex',

      -- vim related
      'lua',
      'vimdoc',
      'vim',
    },

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
  }
end, 0)

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.

local servers = {
  rust_analyzer = {},
  pyright = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = {
        -- ignore Lua_LS's noisy `missing-fields` warnings
        disable = { 'missing-fields' },
        globals = { 'vim' },
      },
    },
  },
  terraformls = {
    cmd = { "terraform-ls", "serve" },
    filetypes = { 'terraform', 'terraform-vars' },
    root_markers = { ".terraform", ".git", "terraform/" },
    root_dir = function(fname)
      -- Check if file is in a terraform/ directory
      local terraform_dir = vim.fn.fnamemodify(fname, ':p:h:s?.*terraform/??')
      if terraform_dir ~= vim.fn.fnamemodify(fname, ':p:h') then
        return vim.fn.fnamemodify(fname, ':p:h:s?/terraform/.*??') .. '/terraform'
      end
      -- Fallback to default root markers
      return require('lspconfig.util').root_pattern('.terraform', '.git')(fname)
    end,
  },
  sqlls = { filetypes = { 'sql', }, },
  ts_ls = {
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  },
  vacuum = {
    cmd = { 'vacuum', 'language-server' },
    filetypes = { 'yaml.openapi' },
  },
  markdown_oxide = {
    cmd = { "markdown-oxide" },
    filetypes = { "markdown" },
    root_markers = { ".git", ".obsidian", ".moxide.toml" }
  },
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)


require('mason-lspconfig').setup {
  ensure_installed = vim.tbl_keys(servers),
}

-- Configure LSP servers using vim.lsp.enable()
for server_name, config in pairs(servers) do
  vim.lsp.enable(server_name, {
    capabilities = capabilities,
    settings = config,
    filetypes = config.filetypes,
  })
end


vim.g.fugitive_open_cmd = 'edit'



--     textobjects = {
--       select = {
--         enable = true,
--         lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
--         keymaps = {
--           -- You can use the capture groups defined in textobjects.scm
--           ['aa'] = '@parameter.outer',
--           ['ia'] = '@parameter.inner',
--           ['af'] = '@function.outer',
--           ['if'] = '@function.inner',
--           ['ac'] = '@class.outer',
--           ['ic'] = '@class.inner',
--         },
--       },
--       move = {
--         enable = true,
--         set_jumps = true, -- whether to set jumps in the jumplist
--         goto_next_start = {
--           [']m'] = '@function.outer',
--           [']]'] = '@class.outer',
--         },
--         goto_next_end = {
--           [']M'] = '@function.outer',
--           [']['] = '@class.outer',
--         },
--         goto_previous_start = {
--           ['[m'] = '@function.outer',
--           ['[['] = '@class.outer',
--         },
--         goto_previous_end = {
--           ['[M'] = '@function.outer',
--           ['[]'] = '@class.outer',
--         },
--       },
--       swap = {
--         enable = true,
--         swap_next = {
--           ['<leader>a'] = '@parameter.inner',
--         },
--         swap_previous = {
--           ['<leader>A'] = '@parameter.inner',
--         },
--       },
--     },
--   }
-- end, 0)
--
-- -- [[ Configure LSP ]]
-- --  This function gets run when an LSP connects to a particular buffer.
--   -- NOTE: Remember that lua is a real programming language, and as such it is possible
--   -- to define small helper and utility functions so you don't have to repeat yourself
--   -- many times.
--   --
--   -- In this case, we create a function that lets us more easily define mappings specific
--   -- for LSP related items. It sets the mode, buffer and description for us each time.
--
--   nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
--   nmap('<leader>ca', function()
--     vim.lsp.buf.code_action { context = { only = { 'quickfix', 'refactor', 'source' } } }
--   end, '[C]ode [A]ction')
--
--   nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
--   nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
--   nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
--   nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
--
--   -- See `:help K` for why this keymap
--   nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
--   nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
--
--   -- Lesser used LSP functionality
--   nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
--   nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
--   nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
--   nmap('<leader>wl', function()
--     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--   end, '[W]orkspace [L]ist Folders')
--
--   -- Create a command `:Format` local to the LSP buffer
--   vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
--     vim.lsp.buf.format()
--   end, { desc = 'Format current buffer with LSP' })
-- end
--
-- -- document existing key chains
require('which-key').add({
  { "<leader>f",   group = "Find" },
  { "<leader>f_",  hidden = true },
  { "<leader>l",   group = "LSP" },
  { "<leader>l_",  hidden = true },
  { "<leader>lr",  group = "Refactor" },
  { "<leader>lr_", hidden = true },

  --   ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
  --   ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
  --   ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
  --   ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
  --   ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
  --   ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
  --   ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
  --   ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
})
-- -- register which-key VISUAL mode
-- -- required for visual <leader>hs (hunk stage) to work
-- require('which-key').register({
--   ['<leader>'] = { name = 'VISUAL <leader>' },
--   ['<leader>h'] = { 'Git [H]unk' },
-- }, { mode = 'v' })
--
--
-- -- Setup neovim lua configuration
-- require('neodev').setup()
--
--
-- -- Ensure the servers above are installed
--
-- -- [[ Configure nvim-cmp ]]
-- -- See `:help cmp`
local cmp = require('cmp')
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {
}
--
cmp.setup {
  window = {
    documentation = cmp.config.disable
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
  },
}

vim.api.nvim_create_user_command('G', function(opts)
  if opts.args == "" then
    vim.cmd('Ge:')
  else
    vim.cmd('Git ' .. opts.args)
  end
end, {
  nargs = '*',
  complete = 'file',
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = {
    "*.tf",
    "*.tfvars",
    "*.lua",
  },
  callback = function()
    vim.lsp.buf.format()
  end,
})

function CloseBuffer()
  -- Check if we're already on Alpha dashboard
  if vim.bo.filetype == 'alpha' then
    return -- Do nothing if already on Alpha
  end

  -- Simple approach: just execute the same command that works manually
  local ok, err = pcall(function()
    vim.cmd('bp | bd #')
  end)

  -- If that fails (e.g., no previous buffer), fall back to Alpha
  if not ok then
    vim.cmd('Alpha')
    -- Force close any remaining buffer to clear bufferline
    vim.schedule(function()
      local bufs = vim.fn.getbufinfo({ buflisted = 1 })
      for _, buf in ipairs(bufs) do
        if buf.name ~= '' then -- Don't close unnamed buffers
          vim.cmd('bd! ' .. buf.bufnr)
        end
      end
    end)
  end
end

vim.keymap.set('n', '<leader>x', CloseBuffer, { desc = "Close Buffer" })
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, desc = "Explorer", silent = true })

-- :help windows split horizontally and on the right side
-- vim.api.nvim_create_autocmd("WinNew", {
--     group = vim.api.nvim_create_augroup("help_window_horizontal", {}),
--     pattern = "*",
--     callback = function()
--         vim.cmd("wincmd L")
--     end
-- })


-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
