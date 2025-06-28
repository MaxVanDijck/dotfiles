return {
  'nathom/filetype.nvim',
  config = function()
    require("filetype").setup({
      overrides = {
        extensions = {
          tf = 'terraform',
          tmpl = "yaml", -- Useful for concourse pipelines where we are using templates
          sh = "sh",     -- Bash scripts don't register correctly
        },
        literal = {
          ["openapi.yaml"] = "yaml.openapi",
          ["openapi.yml"] = "yaml.openapi",
        }
      }
    })
  end
}
