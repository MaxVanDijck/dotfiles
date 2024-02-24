 return  {
     'nathom/filetype.nvim',
     config = function()
        require("filetype").setup({
          overrides = {
              extensions = {
                -- Set the filetype of *.tf files to hcl_custom_tf
                -- This is so we can use HCL syntax highlighting and terraform linters without breaking regular .hcl files
                tf = "hcl_custom_tf",
                tmpl = "yaml",
              },
          }
      })
    end
}
