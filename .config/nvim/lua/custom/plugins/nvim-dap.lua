return {
     -- Autocompletion
     'mfussenegger/nvim-dap',
    lazy = false,
    config = function()
      local dap = require('dap')
        dap.adapters.lldb = {
            type = "executable",
            command = "/usr/bin/lldb", -- adjust as needed
            name = "lldb",
        }
      dap.configurations.rust = {
      {
          name = "hello-world",
          type = "lldb",
          request = "launch",
          program = function()
              return vim.fn.getcwd() .. "/target/debug/hello-world"
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
      },
    }
    end,
}
