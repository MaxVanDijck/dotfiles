return {
  'mrcjkb/rustaceanvim',
  version = '^4', -- Recommended
  ft = { 'rust' },
     dependencies = {
    'neovim/nvim-lspconfig'
  },
  setup = function()

  -- rust settings
  local on_attach = require('lspconfig').on_attach
  local capabilities = require('lspconfig').capabilities

  local options = {
    server = {
      on_attach = on_attach,
      capabilities = capabilities,
    },
  }
    require('rustaceanvim').setup(options)
  end
}
